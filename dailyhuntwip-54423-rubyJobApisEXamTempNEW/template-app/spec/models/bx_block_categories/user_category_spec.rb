# == Schema Information
#
# Table name: user_categories
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_user_categories_on_account_id   (account_id)
#  index_user_categories_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (category_id => categories.id)
#
require 'rails_helper'

RSpec.describe BxBlockCategories::UserCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:category).class_name('BxBlockCategories::Category')}
  end
end
