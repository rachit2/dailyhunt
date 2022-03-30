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
require 'rails_helper'

RSpec.describe BxBlockContentmanagement::TestQuestion, type: :model do
  describe 'associations' do
    it { should belong_to(:questionable) }
    it { should have_many(:options).class_name('BxBlockContentmanagement::Option').dependent(:destroy) }
  end
    
  describe 'validations' do
    it { should validate_presence_of(:question) }
    it { should validate_presence_of(:options_number) }
  end
end
