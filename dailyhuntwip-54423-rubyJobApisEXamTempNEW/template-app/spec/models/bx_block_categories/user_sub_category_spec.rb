# == Schema Information
#
# Table name: user_sub_categories
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#  sub_category_id :bigint           not null
#
# Indexes
#
#  index_user_sub_categories_on_account_id       (account_id)
#  index_user_sub_categories_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (sub_category_id => sub_categories.id)
#
require 'rails_helper'

RSpec.describe BxBlockCategories::UserSubCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:sub_category).class_name('BxBlockCategories::SubCategory')}
  end
end
