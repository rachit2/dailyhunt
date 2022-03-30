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
  class Vote < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :votes

    belongs_to :question, class_name: 'BxBlockCommunityforum::Question'
    belongs_to :account, class_name: 'AccountBlock::Account'

    validates :account_id, uniqueness: { scope: :question_id, message: "vote for this question with this account is already taken"}
  end
end
