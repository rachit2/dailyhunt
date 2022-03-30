module BxBlockForgotPassword
  class OtpConfirmationsController < ApplicationController
    def create
      if create_params[:token].present? && create_params[:otp_code].present?
        # Try to decode token with OTP information
        begin
          token = BuilderJsonWebToken.decode(create_params[:token])
        rescue JWT::ExpiredSignature
          return render json: {
            errors: [{
              pin: app_t('controllers.password.errors.otp_has_expired'),
            }],
          }, status: :unauthorized
        rescue JWT::DecodeError => e
          return render json: {
            errors: [{
              token: app_t('controllers.password.errors.invalid_token'),
            }],
          }, status: :bad_request
        end

        # Try to get OTP object from token
        begin
          otp = token.type.constantize.find(token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {
            errors: [{
              otp: app_t('controllers.password.errors.token_invalid'),
            }],
          }, status: :unprocessable_entity
        end

        # Check OTP code
        if otp.pin == create_params[:otp_code].to_i
          otp.activated = true
          otp.save
          render json: {
            messages: [{
              otp: app_t('controllers.password.otp_validation_success'),
            }],
          }, status: :created
        else
          return render json: {
            errors: [{
              otp: app_t('controllers.password.errors.invalid_token'),
            }],
          }, status: :unprocessable_entity
        end
      else
        return render json: {
          errors: [{
            otp: app_t('controllers.password.errors.token_otp_required'),
          }],
        }, status: :unprocessable_entity
      end
    end

    private

    def create_params
      params.require(:data)
        .permit(*[
          :email,
          :full_phone_number,
          :token,
          :otp_code,
          :new_password,
        ])
    end
  end
end
