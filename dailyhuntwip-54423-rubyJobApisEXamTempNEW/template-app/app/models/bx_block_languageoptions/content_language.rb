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
module BxBlockLanguageoptions
  class ContentLanguage < ApplicationRecord
    self.table_name = :contents_languages

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :language

    rails_admin do
      visible false
    end
    
  end
end
