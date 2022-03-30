module BxBlockRolesPermissions
  class PartnersController < ApplicationController

    def new
      @admin_user = BxBlockAdmin::AdminUser.new
      @admin_user.build_partner
    end

    def create
      partner_role = BxBlockRolesPermissions::Role.find_by(name: "partner")
      admin_attributes = partner_params.merge!(role: partner_role)
      admin_attributes["partner_attributes"] = admin_attributes["partner_attributes"].merge(created_by_admin: false)
      @admin_user = BxBlockAdmin::AdminUser.new(admin_attributes)
      @admin_user.set_random_password

      if @admin_user.save
        flash[:success] = "Partner Signed up Successfully, You will receive an email regarding your registration status!"
        redirect_to  Rails.application.routes.url_helpers.new_admin_user_session_path
      else
        flash[:error] = @admin_user.errors.full_messages.to_sentence
        render :new
      end
    end

    def terms_and_condition
    end

    private

    def partner_params
      params.require(:bx_block_admin_admin_user).permit(:email, partner_attributes: [:name, :address, :spoc_name, :spoc_contact, :status, :category_ids => [], :sub_category_ids => [], :content_type_ids => [], video_attributes: {}, pdf_attributes: {}])
    end
  end
end
