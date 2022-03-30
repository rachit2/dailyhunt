# == Schema Information
#
# Table name: options
#
#  id               :bigint           not null, primary key
#  answer           :string
#  description      :text
#  is_right         :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  test_question_id :bigint           not null
#
# Indexes
#
#  index_options_on_test_question_id  (test_question_id)
#
# Foreign Keys
#
#  fk_rails_...  (test_question_id => test_questions.id)
#
module BxBlockContentmanagement
  class OptionSerializer < BuilderBase::BaseSerializer
    attributes :id, :answer, :description, :is_right, :created_at, :updated_at
  end
end
