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
module BxBlockCommunityforum
  class Answer < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :answers

    has_many :comments, as: :commentable, class_name: "BxBlockCommunityforum::Comment"
    has_many :likes, as: :likeable, class_name: "BxBlockCommunityforum::Like"
    belongs_to :question, class_name: "BxBlockCommunityforum::Question"
    belongs_to :account, class_name: "AccountBlock::Account"
  end
end
