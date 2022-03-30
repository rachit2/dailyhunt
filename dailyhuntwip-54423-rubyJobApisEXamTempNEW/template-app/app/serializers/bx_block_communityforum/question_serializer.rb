# == Schema Information
#
# Table name: questions
#
#  id              :bigint           not null, primary key
#  closed          :boolean
#  description     :text
#  image           :string
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
  class QuestionSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :description, :account, :sub_category, :image, :view, :tags, :status, :votes_count, :likes_count, :dislikes_count, :comments_count, :is_popular, :is_trending, :closed, :created_at, :updated_at

    attribute :image do |object|
      object.image_url
    end

    attribute :answers, if: Proc.new { |record, params|
      params && params[:answers] == true
    }

    attribute :comments, if: Proc.new { |record, params|
      params && params[:comments] == true
    } do |object, params|
      CommentSerializer.new(object.comments, params:{comments:true, current_user_id:params[:current_user_id]}).serializable_hash[:data]
    end

    attributes :user_image do |object|
      object.account.image.image_url if object.account.present? and object.account.image.present?
    end

    attribute :is_like do |object, params|
      if params && params[:current_user_id]
        object.likes.where(account_id: params[:current_user_id], is_like: true).present?
      else
        false
      end
    end

  end
end
