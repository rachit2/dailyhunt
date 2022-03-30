# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#  question_id :bigint
#
# Indexes
#
#  index_answers_on_account_id   (account_id)
#  index_answers_on_question_id  (question_id)
#
require 'rails_helper'

RSpec.describe BxBlockCommunityforum::Answer, type: :model do

  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:question).class_name('BxBlockCommunityforum::Question') }
    it { should have_many(:comments).class_name('BxBlockCommunityforum::Comment') }
    it { should have_many(:likes).class_name('BxBlockCommunityforum::Like') }
  end  
end
