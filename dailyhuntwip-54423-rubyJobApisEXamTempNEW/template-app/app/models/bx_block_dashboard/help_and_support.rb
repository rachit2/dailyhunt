# == Schema Information
#
# Table name: help_and_supports
#
#  id         :bigint           not null, primary key
#  answer     :text
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockDashboard
	class HelpAndSupport < ApplicationRecord
		self.table_name = :help_and_supports

		validates :question, :answer, presence: true

		def name
			question
		end
	end
end
