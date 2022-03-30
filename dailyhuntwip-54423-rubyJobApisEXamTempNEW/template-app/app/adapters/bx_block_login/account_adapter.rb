module BxBlockLogin
  class AccountAdapter
    include Wisper::Publisher

    def login_account(account_params, token)

      case account_params.type
      when 'sms_account'

        sms_otp = AccountBlock::SmsOtp.find_by(id: token.id, activated: true)
        unless sms_otp.present?
          broadcast(:phone_no_not_verified)
          return
        end

        phone = Phonelib.parse(sms_otp.full_phone_number).sanitized
        account = AccountBlock::Account
          .where(full_phone_number: phone, activated: true)
          .first_or_create(type: "SmsAccount", full_phone_number: phone, activated: true)

        sms_otp.destroy!
      when 'email_account'
        email_otp = AccountBlock::EmailOtp.find_by(id: token.id, activated: true)

        unless email_otp.present?
          broadcast(:email_not_verified)
          return
        end

        query_email = email_otp.email.downcase

        account = AccountBlock::Account
          .where('LOWER(email) = ?', query_email)
          .first_or_create(email: query_email, type: "EmailAccount", activated: true)

        email_otp.destroy!
      end

      unless account.persisted?
        broadcast(:account_not_created, account)
        return
      end

      token = BuilderJsonWebToken.encode(account.id)
      broadcast(:successful_login, account, token)
    end
  end
end
