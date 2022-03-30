# == Schema Information
#
# Table name: contents_languages
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#  language_id :bigint           not null
#
# Indexes
#
#  index_contents_languages_on_account_id   (account_id)
#  index_contents_languages_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (language_id => languages.id)
#
require 'rails_helper'

RSpec.describe BxBlockLanguageoptions::ContentLanguage, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:language).class_name('BxBlockLanguageoptions::Language') }
  end
end
