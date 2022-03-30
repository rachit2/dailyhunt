module BxBlockLogin
  class LoginsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:create]

    def create
      case params[:data][:type] #### rescue invalid API format
      when 'sms_account', 'email_account', 'social_account'
        account = OpenStruct.new(jsonapi_deserialize(params))
        account.type = params[:data][:type]

        output = AccountAdapter.new

        output.on(:account_not_created) do |account|
          render json: {
            errors: format_activerecord_errors(account.errors),
          }, status: :unprocessable_entity
        end

        output.on(:failed_login) do |account|
          render json: {
            errors: [{
              failed_login: app_t('controllers.login.errors.failed_login'),
            }],
          }, status: :unauthorized
        end

        output.on(:phone_no_not_verified) do |account|
          render json: {
            errors: [{
              phone: app_t('controllers.accounts.errors.phone_number_not_verified_yet')
            }],
          }, status: :unprocessable_entity
        end

        output.on(:email_not_verified) do |account|
          render json: {
            errors: [{
              email: "Email Not Verified Yet"
            }],
          }, status: :unprocessable_entity
        end

        output.on(:email_invalid) do |account|
          render json: {
            errors: [{
              account: 'Email invalid'},
          ]}, status: :unprocessable_entity
        end

        output.on(:successful_login) do |account, token|
          render json: {meta: {token: token}}
        end

        output.login_account(account, @token)
      else
        render json: {
          errors: [{
            account: app_t('controllers.login.errors.invalid_type'),
          }],
        }, status: :unprocessable_entity
      end
    end

    def partner_login
      admin_user = BxBlockAdmin::AdminUser.find_by(email: params[:email])

      unless admin_user.present? && admin_user.valid_password?(params[:password]) && admin_user.partner?
        return render json: {errors: [{failed_login: "Login Failed"}]}, status: :unauthorized
      end

      admin =  admin_user if admin_user.present? && admin_user.partner.approved?
      return render json: { success: false, errors: {failed_login: 'Admin User is not approved'}, admin_details: admin_user}, status: :unprocessable_entity if admin.nil? && admin_user.present?

      token = BuilderJsonWebToken.encode(admin.id)
      render json: { success: true, admin: admin, meta: {token: token}}
    end
  end
end
