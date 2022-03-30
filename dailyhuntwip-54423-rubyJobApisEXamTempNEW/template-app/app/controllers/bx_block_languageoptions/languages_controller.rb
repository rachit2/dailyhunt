module BxBlockLanguageoptions
  class LanguagesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index, :get_all_translations, :last_translation_time]

    def index
      case params[:type]
      when 'content_languages'
        languages = BxBlockLanguageoptions::Language.content_languages
      when 'app_languages'
        languages = BxBlockLanguageoptions::Language.app_languages
      else
        languages = BxBlockLanguageoptions::Language.all
      end
      serializer = LanguageSerializer.new(languages)
      render json: serializer, status: :ok
    end

    def set_app_language
      if current_user.update(app_language_id: params[:app_language_id])
        serializer = LanguageSerializer.new(current_user.app_language)
        serialized = serializer.serializable_hash
        render :json => serialized
      else
        render :json => {:errors => current_user.errors,
          :status => :unprocessable_entity}
      end
    end

    def update
      if current_user.update(language_ids: params[:languages_ids])
        serializer = LanguageSerializer.new(current_user.languages)
        serialized = serializer.serializable_hash
        render :json => serialized
      else
        render :json => {:errors => current_user.errors,
          :status => :unprocessable_entity}
      end
    end

    def get_all_translations
      application_messages = BxBlockLanguageoptions::ApplicationMessage.all.includes(:translations)
      render json: SerializeTranslations.call(application_messages)
    end

    def last_translation_time
      render :json => {last_transation_time: BxBlockLanguageoptions::ApplicationMessage.order(:updated_at).last&.updated_at}
    end
  end
end
