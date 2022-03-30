module BxBlockLogin
  class SocialLoginController < ApplicationController
    def create
      response = get_response(params[:data][:type], params[:data][:attributes])
      post_response(response)
    end

    def apple_login_callback
      response =BxBlockLogin::AppleDetailsApi.callback(params[:code], params[:id_token])
      post_response(response)
    end

    private
    def get_response(type, attributes)
      case type
      when 'google'
        BxBlockLogin::GoogleDetailsApi.call(attributes[:access_token])
      when 'facebook'
        BxBlockLogin::FacebookDetailsApi.call(attributes[:access_token])
      when 'apple'
        BxBlockLogin::AppleDetailsApi.call(attributes[:user_identity], attributes[:jwt])
      when 'linkedin'
        BxBlockLogin::LinkedinDetailsApi.call(attributes[:code])
      when 'linkedin_mobile'
        BxBlockLogin::LinkedinDetailsApi.get_details(attributes[:access_token])
      else
        {success: false, error: "Invalid Login Type: #{type}"}
      end
    end

    def post_response(response)
      if response[:success]
        email = response[:email].to_s.downcase
        first_name = response[:first_name]
        unique_auth_id = response[:unique_auth_id]
        if email.present?
          account = AccountBlock::Account
            .where('LOWER(email) = ?', email)
            .first_or_create(email: email, first_name: first_name, type: "SocialAccount", activated: true)
        else
          account = unique_auth_id.present? ? AccountBlock::Account.find_by(unique_auth_id: unique_auth_id) : nil
          return render json: {
              errors: "Please share your Email, Email not shared by #{response[:type].capitalize}",
            }, status: :unprocessable_entity unless account
        end

        is_new_user = false
        if account.persisted?
          account.update(unique_auth_id: unique_auth_id) if response[:type] == 'apple'
          token = BuilderJsonWebToken.encode(account.id)

          render json: AccountBlock::AccountSerializer.new(account, meta: {
            is_new_user: is_new_user,
            email: response[:email],
            token: token,
          }).serializable_hash
        else
          render json: {
            errors: format_activerecord_errors(account.errors),
          }, status: :unprocessable_entity
        end
      else
        render json: {
          errors: [{
            error: response[:error],
          }]
        }, status: :unprocessable_entity
      end
    end
  end
end
