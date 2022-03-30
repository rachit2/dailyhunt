# == Schema Information
#
# Table name: languages
#
#  id                  :bigint           not null, primary key
#  name                :string
#  language_code       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  is_content_language :boolean
#  is_app_language     :boolean
#
require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::Language, type: :model do
  describe 'associations' do
    it { should have_many(:contents_languages).class_name('BxBlockLanguageoptions::ContentLanguage').dependent(:destroy) }
    it { should have_many(:accounts).class_name('AccountBlock::Account').through(:contents_languages) }
    it { should have_many(:contents).class_name('BxBlockContentmanagement::Content').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:language_code) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_uniqueness_of(:language_code).case_insensitive }
  end
end
