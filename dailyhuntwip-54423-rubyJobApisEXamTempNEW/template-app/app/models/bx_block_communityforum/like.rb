# == Schema Information
#
# Table name: likes
#
#  id            :bigint           not null, primary key
#  is_like       :boolean
#  likeable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint
#  likeable_id   :bigint
#
# Indexes
#
#  index_likes_on_account_id  (account_id)
#
module BxBlockCommunityforum
  class Like < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :likes

    TYPE_MAPPINGS = {
      "question" => BxBlockCommunityforum::Question.name,
      "answer" => BxBlockCommunityforum::Answer.name,
      "comment" => BxBlockCommunityforum::Comment.name
    }.freeze

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :likeable, polymorphic: true
    validates :account_id, :uniqueness => { :scope => [:likeable_type, :likeable_id], message: "like is already taken" }
  end
end
