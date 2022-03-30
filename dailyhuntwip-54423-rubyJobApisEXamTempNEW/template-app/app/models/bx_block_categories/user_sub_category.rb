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
module BxBlockCategories
  class UserSubCategory < ApplicationRecord
    self.table_name = :user_sub_categories

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :sub_category

    rails_admin do
      visible false
    end
    
  end
end
