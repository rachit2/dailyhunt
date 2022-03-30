# BxBlockLanguageoptions::SetAvailableLocales.call
module BxBlockLanguageoptions
  class SetAvailableLocales
    class << self
      def call
        language_codes = [I18n.default_locale.to_s]
        language_codes.push(*BxBlockLanguageoptions::Language.pluck(:language_code).compact) if BxBlockLanguageoptions::Language.table_exists? rescue false
        I18n.available_locales = language_codes.uniq
      end
    end
  end
end
