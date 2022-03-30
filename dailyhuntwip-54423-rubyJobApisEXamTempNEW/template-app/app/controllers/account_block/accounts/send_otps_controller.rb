# frozen_string_literal: true

module AccountBlock
  module Accounts
    class SendOtpsController < ApplicationController
      def create
        json_params = jsonapi_deserialize(params)
        if json_params['email'].present?
          validator = AccountBlock::EmailValidation.new(json_params['email'])

          if !validator.valid?
            return render json: {
              errors: [{
                account: app_t('controllers.accounts.errors.email_invalid'),
              }],
            }, status: :unprocessable_entity
          end

          email_otp = EmailOtp.new(jsonapi_deserialize(params))
          if email_otp.save
            send_email_for email_otp
            render json: serialized_email_otp(email_otp),
              status: :created
          else
            render json: {
              errors: [email_otp.errors],
            }, status: :unprocessable_entity
          end
        else
          @sms_otp = SmsOtp.new(jsonapi_deserialize(params))
          if @sms_otp.save
            render json: SmsOtpSerializer.new(@sms_otp, meta: {
              token: BuilderJsonWebToken.encode(@sms_otp.id),
            }).serializable_hash, status: :created
          else
            render json: {errors: format_activerecord_errors(@sms_otp.errors)},
              status: :unprocessable_entity
          end
        end
      end

      private

      def send_email_for(otp_record)
        BxBlockForgotPassword::EmailOtpMailer.with(otp: otp_record, host: request.base_url).otp_email.deliver
      end

      def serialized_email_otp(email_otp)
        token = BuilderJsonWebToken.encode(email_otp.id)
        EmailOtpSerializer.new(email_otp, meta: {
              token: BuilderJsonWebToken.encode(email_otp.id),
            }).serializable_hash
      end

      def format_activerecord_errors(errors)
        result = []
        errors.each do |attribute, error|
          result << { attribute => error }
        end
        result
      end
    end
  end
end
