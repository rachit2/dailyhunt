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
  class CommentSerializer < BuilderBase::BaseSerializer

    attributes :id, :description, :commentable_id, :commentable_type, :account, :likes_count, :dislikes_count, :comments_count, :created_at, :updated_at

    attributes :user_image do |object|
      object.account.image.image_url if object.account.present? and object.account.image.present?
    end

    attribute :comments, if: Proc.new { |record, params|
      params && params[:comments] == true
    } do |object, params|
      CommentSerializer.new(object.comments, params:{comments:true, current_user_id:params[:current_user_id]}).serializable_hash[:data]
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
