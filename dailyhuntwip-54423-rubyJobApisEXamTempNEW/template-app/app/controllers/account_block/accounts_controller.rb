module AccountBlock
  class AccountsController < ApplicationController
    def create
      case params[:data][:type] #### rescue invalid API format
      when 'sms_account'
        validate_json_web_token

        # unless valid_token?
        #   return render json: {errors: [
        #     {token: 'Invalid Token'},
        #   ]}, status: :bad_request
        # end

        begin
          @sms_otp = SmsOtp.find_by!(id: @token.id, activated: true)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {phone: app_t('controllers.accounts.errors.phone_number_not_verified_yet')},
          ]}, status: :unprocessable_entity
        end

        params[:data][:attributes][:full_phone_number] =
          @sms_otp.full_phone_number
        @account = SmsAccount.new(jsonapi_deserialize(params))
        @account.activated = true
        if @account.save
          @account.update(phone_verified: true) unless @account.phone_verified
          render json: SmsAccountSerializer.new(@account, meta: {
            token: encode(@account.id)
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      when 'email_account'
        account_params = jsonapi_deserialize(params)

        query_email = account_params['email'].downcase
        account = EmailAccount.where('LOWER(email) = ?', query_email).first

        validator = EmailValidation.new(account_params['email'])

        return render json: {errors: [
          {account: 'Email invalid'},
        ]}, status: :unprocessable_entity if account || !validator.valid?

        puts " - params = #{params}"
        puts " - jsonapi_deserialize(params) = #{jsonapi_deserialize(params)}"
        @account = EmailAccount.new(jsonapi_deserialize(params))
        if @account.save
          @account.update(email_verified: true) unless @account.email_verified
          EmailValidationMailer
            .with(account: @account, host: request.base_url)
            .activation_email.deliver
          render json: EmailAccountSerializer.new(@account, meta: {
            token: encode(@account.id),
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      when 'social_account'
        @account = SocialAccount.new(jsonapi_deserialize(params))
        @account.password = @account.email
        if @account.save
          render json: SocialAccountSerializer.new(@account, meta: {
            token: encode(@account.id),
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      else
        render json: {errors: [
          {account: app_t('controllers.accounts.errors.invalid_type')},
        ]}, status: :unprocessable_entity
      end
    end

    private

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def encode(id)
      BuilderJsonWebToken.encode id
    end
  end
end
