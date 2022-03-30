module BxBlockProfile
  class ProfilesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:caste_category]

    def show
      account_id = @token.id

      account = AccountBlock::Account.find(account_id)
      serializer = AccountBlock::AccountSerializer.new(account)
      serialized = serializer.serializable_hash

      render :json => serialized
    end

    def update
      status, result = UpdateAccountCommand.execute(@token.id, update_params)
      if status == :ok
        serializer = AccountBlock::AccountSerializer.new(result)
        render :json => serializer.serializable_hash,
          :status => :ok
      else
        render :json => {:errors => [{:profile => result.first}]},
          :status => status
      end
    end

    def caste_category
      render :json => {data: BxBlockProfile::GovtJob.caste_categories.keys}
    end

    def delete_profile_categories_data
      current_user.update!(category_ids: current_user.category_ids - params[:deleted_category_ids].map(&:to_i))
      deleted_categories = BxBlockCategories::Category.where(id: params[:deleted_category_ids])
      profile = current_user.profile
      if !profile || profile.clear_fields_for(deleted_categories.pluck(:identifier).compact)
        render :json => AccountBlock::AccountSerializer.new(current_user).serializable_hash, status: :ok
      else
        render json: {errors: format_activerecord_errors(profile.errors)}, status: :unprocessable_entity
      end
    end

    private

    def update_params
      params.require(:data).permit \
        :first_name,
        :new_email,
        :new_phone_number,
        :city,
        :dob,
        :gender,
        :device_id,
        :desktop_device_id,
        category_ids: [],
        sub_category_ids: [],
        image_attributes: [:id, :image, :_destroy],
        profile_attributes: Profile::PROFILE_PARAMS
    end
  end
end
