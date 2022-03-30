# == Schema Information
#
# Table name: questions
#
#  id              :bigint           not null, primary key
#  closed          :boolean
#  description     :text
#  image           :string
#  is_popular      :boolean
#  is_trending     :boolean
#  status          :integer
#  title           :string
#  view            :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#  sub_category_id :bigint
#
# Indexes
#
#  index_questions_on_account_id       (account_id)
#  index_questions_on_sub_category_id  (sub_category_id)
#
module BxBlockCommunityforum
  class Question < BxBlockCommunityforum::ApplicationRecord
    self.table_name = :questions

    has_many :answers, class_name: "BxBlockCommunityforum::Answer", dependent: :destroy
    has_many :votes, class_name: "BxBlockCommunityforum::Vote", dependent: :destroy
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :sub_category, class_name: "BxBlockCategories::SubCategory", dependent: :destroy
    has_many :comments, as: :commentable, class_name: "BxBlockCommunityforum::Comment"
    has_many :likes, as: :likeable, class_name: "BxBlockCommunityforum::Like"

    acts_as_taggable_on :tags

    mount_uploader :image, ImageUploader

    enum status: ["draft", "publish"]

    scope :total_likes, -> { joins(:likes).where(likes: {is_like: true}).count }
    scope :total_dislikes, -> { joins(:likes).where(likes: {is_like: false}).count }
    scope :total_drafted, -> { where(status: "draft").count }
    scope :popular_questions, -> {where(is_popular:true)}

    def votes_count
      votes&.count rescue 0
    end

    def comments_count
       comments.count rescue 0
    end

    def likes_count
       likes.where(is_like: true).count rescue 0
    end

    def dislikes_count
       likes.where(is_like: false).count rescue 0
    end
  end
end
