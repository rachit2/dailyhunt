module BuilderBase
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    include JSONAPI::Deserialization
    include BuilderJsonWebToken::JsonWebTokenValidation
    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    around_action :set_locale

    before_action :update_current_user

    private

    def not_found
      render :json => {'errors' => [app_t('controllers.application.errors.record_not_found')]}, :status => :not_found
    end

    def current_user
      return unless @token
      account_id = @token.id
      account = AccountBlock::Account.find(account_id)
    end

    def set_locale
      lang = params[:language] || I18n.default_locale
      Globalize.with_locale(lang) do
        yield
      end
    end

    def format_activerecord_errors(errors)
      [{ error: errors.full_messages.first }]
    end

    def app_t(key)
      BxBlockLanguageoptions::ApplicationMessage.translation_message(key)
    end

    def update_current_user
     current_user.update(last_visit_at: Time.now) if current_user.present?
    end
  end
end
