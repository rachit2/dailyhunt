# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockDashboard
	class Faq < ApplicationRecord
		self.table_name = :faqs

		validates :question, :answer, presence: true

		def name
			question
		end
	end
end
