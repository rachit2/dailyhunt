# == Schema Information
#
# Table name: ratings
#
#  id              :bigint           not null, primary key
#  rating          :integer
#  review          :string
#  reviewable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#  reviewable_id   :bigint
#
# Indexes
#
#  index_ratings_on_account_id                         (account_id)
#  index_ratings_on_reviewable_type_and_reviewable_id  (reviewable_type,reviewable_id)
#
module BxBlockContentmanagement
	class Rating < ApplicationRecord
		self.table_name = :ratings

		belongs_to :account, class_name: "AccountBlock::Account"
		belongs_to :reviewable, polymorphic: true

		validates :rating, :review, presence: true
		validates :account, uniqueness: { scope: [:reviewable_type, :reviewable_id] }
	end
end
