# frozen_string_literal: true

module AccountBlock
  module Accounts
    class SmsConfirmationsController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token

      def create
        begin
          @sms_otp = SmsOtp.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {phone: app_t('controllers.accounts.errors.phone_not_found')},
          ]}, status: :unprocessable_entity
        end

        if @sms_otp.valid_until < Time.current
          @sms_otp.destroy

          return render json: {errors: [
            {pin: app_t('controllers.accounts.errors.pin_has_expired')},
          ]}, status: :unauthorized
        end

        if @sms_otp.activated?
          return render json: ValidateAvailableSerializer.new(@sms_otp, meta: {
            message: app_t('controllers.accounts.errors.phone_already_activated'),
          }).serializable_hash, status: :ok
        end

        if @sms_otp.pin.to_s == params['pin']
          @sms_otp.activated = true
          @sms_otp.save
          account = AccountBlock::Account.find_by(full_phone_number: @sms_otp.full_phone_number)
          account.update(phone_verified: true) if account.present?

          render json: ValidateAvailableSerializer.new(@sms_otp, meta: {
            message: app_t('controllers.accounts.errors.phone_number_confirmed'),
            token: BuilderJsonWebToken.encode(@sms_otp.id),
          }).serializable_hash, status: :ok
        else
          return render json: {errors: [
            {pin: app_t('controllers.accounts.errors.invalid_pin')},
          ]}, status: :unprocessable_entity
        end
      end
    end
  end
end
