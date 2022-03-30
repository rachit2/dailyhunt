require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::BuildLanguages, type: :services do

  let(:languages_array) {[
    {name: "Hindi", language_code: "hi"},
    {name: "English", language_code: "en"},
    {name: "Telugu", language_code: "te"},
    {name: "Tamil", language_code: "ta"},
    {name: "Marathi", language_code: "mr"},
    {name: "Bangla", language_code: "bn"},
    {name: "Gujarati", language_code: "gu"},
    {name: "Oriya", language_code: "or"}
  ]}

  context 'should create languages' do
    it 'should create those languages which passed in languages array' do
      response = BxBlockLanguageoptions::BuildLanguages.call(languages_array)
      expected_langauges_names = BxBlockLanguageoptions::Language.where("lower(name) IN (?)", languages_array.pluck(:name).map(&:downcase)).pluck(:name)
      expected_languages_codes = BxBlockLanguageoptions::Language.where("lower(name) IN (?)", languages_array.pluck(:name).map(&:downcase)).pluck(:language_code)
      response_langauges_names = response.pluck(:name)
      response_langauges_codes = response.pluck(:language_code)
      expect(response_langauges_names.sort).to match_array(expected_langauges_names.sort)
      expect(response_langauges_codes.sort).to match_array(expected_languages_codes.sort)
    end

    it 'should create languages when we does not pass any languages' do
      response = BxBlockLanguageoptions::BuildLanguages.call
      expected_langauges_names = BxBlockLanguageoptions::Language.where("lower(name) IN (?)", languages_array.pluck(:name).map(&:downcase)).pluck(:name)
      expected_languages_codes = BxBlockLanguageoptions::Language.where("lower(name) IN (?)", languages_array.pluck(:name).map(&:downcase)).pluck(:language_code)
      response_langauges_names = response.pluck(:name)
      response_langauges_codes = response.pluck(:language_code)
      expect(response_langauges_names).to match_array(expected_langauges_names)
      expect(response_langauges_codes).to match_array(expected_languages_codes)
    end

  end

  
end