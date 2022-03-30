# == Schema Information
#
# Table name: freetrails
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint
#  course_id  :bigint
#
# Indexes
#
#  index_freetrails_on_account_id  (account_id)
#  index_freetrails_on_course_id   (course_id)
#
module BxBlockContentmanagement
	class Freetrail < ApplicationRecord
		self.table_name = :freetrails
		validate :check_free_trail_available

		belongs_to :course
		belongs_to :account, class_name: 'AccountBlock::Account'
		validates_uniqueness_of :course_id, :scope => [:account_id]

		private

		def check_free_trail_available
			unless course&.available_free_trail
				errors.add(:course, "not available for free trail.")
			end
		end
	end
end
