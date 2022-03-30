require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::SetAvailableLocales, type: :services do
  before(:each) do
    BxBlockLanguageoptions::BuildLanguages.call
  end

  it 'should set correct locales' do
    I18n.available_locales = [:en]
    BxBlockLanguageoptions::SetAvailableLocales.call
    expected_locales = [I18n.default_locale] + BxBlockLanguageoptions::Language.pluck(:language_code).map(&:to_sym)
    expect(I18n.available_locales).to match_array(expected_locales.uniq)
  end
end
