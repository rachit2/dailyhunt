require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::SerializeTranslations, type: :services do
  let!(:application_message1){ FactoryBot.create(:application_message, name:'controllers.login.errors.account_not_found', message:'Account not found, or not activated') }
  let!(:application_message2){ FactoryBot.create(:application_message, name:'controllers.login.errors.failed_login', message: 'Login Failed') }
  let!(:application_message3){ FactoryBot.create(:application_message, name:'controllers.login.errors.invalid_type', message: 'Invalid Account Type') }

  def create_hi_translations
    application_message1.update(locale: :hi, message:'Hindi of Account not found, or not activated')
    application_message2.update(locale: :hi, message:'Hindi of Login Failed')
    application_message3.update(locale: :hi, message:'Hindi of Invalid Account Type')
  end

  let(:en_observed_application_messages_serialized_hash) do
    {
      application_message1.name => 'Account not found, or not activated',
      application_message2.name => 'Login Failed',
      application_message3.name => 'Invalid Account Type',
    }
  end

  let(:hi_observed_application_messages_serialized_hash) do
    {
      application_message1.name => 'Hindi of Account not found, or not activated',
      application_message2.name => 'Hindi of Login Failed',
      application_message3.name => 'Hindi of Invalid Account Type',
    }
  end

  before(:each) do
    I18n.available_locales = [:en, :hi]
    create_hi_translations
  end

  it 'return serialized_hash for en'do
    Globalize.with_locale(:en) do
      application_messages = BxBlockLanguageoptions::ApplicationMessage.all.includes(:translations)
      serialized_hash_output = BxBlockLanguageoptions::SerializeTranslations.call(application_messages)
      expect(serialized_hash_output).to eq(en_observed_application_messages_serialized_hash)
    end
  end

  it 'return serialized_hash for hi'do
    Globalize.with_locale(:hi) do
      application_messages = BxBlockLanguageoptions::ApplicationMessage.all.includes(:translations)
      serialized_hash_output = BxBlockLanguageoptions::SerializeTranslations.call(application_messages)
      expect(serialized_hash_output).to eq(hi_observed_application_messages_serialized_hash)
    end
  end
end
