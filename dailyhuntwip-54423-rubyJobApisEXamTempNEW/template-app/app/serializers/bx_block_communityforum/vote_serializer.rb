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
module BxBlockCommunityforum
  class VoteSerializer < BuilderBase::BaseSerializer
    attributes :id, :question, :account, :created_at, :updated_at
  end
end
