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
  class AnswerSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :description, :account, :question, :created_at, :updated_at,:user_image

    attribute :comments, if: Proc.new { |record, params|
      params && params[:comments] == true
    }

    attributes :user_image do |object|
      object.account.image.image_url if object.account.present? and object.account.image.present?
    end
  end
end
