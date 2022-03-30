# == Schema Information
#
# Table name: votes
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#  question_id :bigint
#
# Indexes
#
#  index_votes_on_account_id   (account_id)
#  index_votes_on_question_id  (question_id)
#
require 'rails_helper'

RSpec.describe BxBlockCommunityforum::Vote, type: :model do

  describe 'associations' do
    it { should belong_to(:account).class_name('AccountBlock::Account') }
    it { should belong_to(:question).class_name('BxBlockCommunityforum::Question') }
  end
end
