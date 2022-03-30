# frozen_string_literal: true

module AccountBlock
  module Accounts
    class EmailConfirmationsController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token

      def create
        begin
          @email_otp = EmailOtp.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {email: 'Email Not Found'},
          ]}, status: :unprocessable_entity
        end

        if @email_otp.valid_until < Time.current
          @email_otp.destroy
          return render json: {errors: [
            {pin: 'This Pin has expired, please request a new pin code.'},
          ]}, status: :unauthorized
        end

        if @email_otp.activated?
          return render json: ValidateAvailableSerializer.new(@email_otp, meta: {
            message: 'Email Already Activated',
          }).serializable_hash, status: :ok
        end

        if @email_otp.pin.to_s == params['pin'].to_s
          @email_otp.activated = true
          @email_otp.save
          account = AccountBlock::Account.find_by(email: @email_otp.email)
          account.update(email_verified: true) if account.present?
          render json: ValidateAvailableSerializer.new(@email_otp, meta: {
            message: 'Email Confirmed Successfully',
            token: BuilderJsonWebToken.encode(@email_otp.id),
          }).serializable_hash, status: :ok
        else
          return render json: {errors: [
            {pin: 'Invalid Pin for Email'},
          ]}, status: :unprocessable_entity
        end
      end

      def show
        begin
          @account = EmailAccount.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {account: app_t('controllers.accounts.errors.account_not_found')},
          ]}, status: :unprocessable_entity
        end

        if @account.activated?
          return render json: ValidateAvailableSerializer.new(@account, meta: {
            message: app_t('controllers.accounts.errors.account_already_activated'),
          }).serializable_hash, status: :ok
        end

        @account.update :activated => true

        render json: ValidateAvailableSerializer.new(@account, meta: {
          message: app_t('controllers.accounts.errors.account_activated_successfully'),
        }).serializable_hash, status: :ok
      end
    end
  end
end
