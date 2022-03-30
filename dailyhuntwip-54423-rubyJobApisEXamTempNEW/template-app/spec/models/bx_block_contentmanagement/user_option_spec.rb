# == Schema Information
#
# Table name: user_options
#
#  id               :bigint           not null, primary key
#  is_true          :boolean
#  optionable_type  :string
#  rank             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  option_id        :bigint           not null
#  optionable_id    :integer
#  test_question_id :bigint           not null
#
# Indexes
#
#  index_user_options_on_option_id         (option_id)
#  index_user_options_on_test_question_id  (test_question_id)
#
# Foreign Keys
#
#  fk_rails_...  (option_id => options.id)
#  fk_rails_...  (test_question_id => test_questions.id)
#
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::UserOption, type: :model do
  describe 'associations' do
    it { should belong_to(:test_question) }
    it { should belong_to(:option) }
    it { should belong_to(:optionable) }
  end
  describe 'validations' do
    # it { should validate_uniquess_of(:optionable_id).scope(::optionable_type, :test_question_id) }
  end
end
