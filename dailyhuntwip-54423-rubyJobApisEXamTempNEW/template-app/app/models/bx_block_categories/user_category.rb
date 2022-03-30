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
module BxBlockCategories
	class UserCategory < ApplicationRecord
		self.table_name = :user_categories

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :category

    rails_admin do
      visible false
    end
	end
end
