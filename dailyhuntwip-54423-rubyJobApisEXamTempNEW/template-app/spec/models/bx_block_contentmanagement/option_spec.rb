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
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::Option, type: :model do

  describe 'associations' do
    it { should belong_to(:test_question).class_name('BxBlockContentmanagement::TestQuestion') }
  end
end
