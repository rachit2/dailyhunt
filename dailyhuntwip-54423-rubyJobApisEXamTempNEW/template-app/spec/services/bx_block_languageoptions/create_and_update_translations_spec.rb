require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::CreateAndUpdateTranslations, type: :services do

  context 'should create en translations' do
    it 'should return en translations' do
      response = BxBlockLanguageoptions::CreateAndUpdateTranslations.call
      translations = YAML.load_file(Rails.root.join("config", "locales/en.yml"))
      def flatten_hash(param, prefix=nil)
        param.each_pair.reduce({}) do |a, (k, v)|
          v.is_a?(Hash) ? a.merge(flatten_hash(v, "#{prefix}#{k}.")) : a.merge("#{prefix}#{k}" => v)
        end
      end
      en_translations = flatten_hash(translations["en"])
      expect(response).to match_array(en_translations)
    end

    it 'should create all en translations that mentioned in en.yml'do
      response = BxBlockLanguageoptions::CreateAndUpdateTranslations.call
      appication_message = BxBlockLanguageoptions::ApplicationMessage.where("lower(name) IN (?)", response.keys.map(&:downcase)).pluck(:message)
      expect(response.values).to match_array(appication_message)
    end
  end

end