# == Schema Information
#
# Table name: test_questions
#
#  id                :bigint           not null, primary key
#  question          :string
#  options_number    :integer
#  questionable_id   :integer
#  questionable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
module BxBlockContentmanagement
	class TestQuestion < ApplicationRecord
		self.table_name = :test_questions

		belongs_to :questionable, polymorphic: true, inverse_of: :test_questions
		validates :question, :options_number, presence: true
    has_many :options, inverse_of: :test_question, class_name: 'BxBlockContentmanagement::Option', dependent: :destroy
    accepts_nested_attributes_for :options, allow_destroy: true

    def name
      question
    end

    def correct_ans
      options.find_by(is_right: true)
    end
	end
end
