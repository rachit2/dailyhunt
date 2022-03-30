# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  commentable_type :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint
#  commentable_id   :bigint
#
# Indexes
#
#  index_comments_on_account_id  (account_id)
#
module BxBlockCommunityforum
  class Comment < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :comments

    TYPE_MAPPINGS = {
      "question" => BxBlockCommunityforum::Question.name,
      "answer" => BxBlockCommunityforum::Answer.name,
      "comment" => BxBlockCommunityforum::Comment.name
    }.freeze

    belongs_to :commentable, polymorphic: true
    belongs_to :account, class_name: "AccountBlock::Account"

    has_many :comments, as: :commentable, class_name: "BxBlockCommunityforum::Comment"
    has_many :likes, as: :likeable, class_name: "BxBlockCommunityforum::Like"

    validates :description, presence: true

    scope :total_likes, -> { joins(:likes).where(likes: {is_like: true}).count }
    scope :total_dislikes, -> { joins(:likes).where(likes: {is_like: false}).count }

    def likes_count
       likes.where(is_like: true).count rescue 0
    end

    def dislikes_count
       likes.where(is_like: false).count rescue 0
    end

    def comments_count
       comments.count rescue 0
    end
    
  end
end
