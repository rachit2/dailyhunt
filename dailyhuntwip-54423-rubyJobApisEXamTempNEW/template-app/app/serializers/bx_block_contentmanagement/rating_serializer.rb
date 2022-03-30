# == Schema Information
#
# Table name: ratings
#
#  id              :bigint           not null, primary key
#  rating          :integer
#  review          :string
#  reviewable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#  reviewable_id   :bigint
#
# Indexes
#
#  index_ratings_on_account_id                         (account_id)
#  index_ratings_on_reviewable_type_and_reviewable_id  (reviewable_type,reviewable_id)
#
module BxBlockContentmanagement
  class RatingSerializer < BuilderBase::BaseSerializer
    attributes :id, :rating, :review, :account_id, :reviewable_type, :reviewable_id, :created_at, :updated_at

    attribute :account_name do |object|
      object.account.name
    end

    attributes :account_image do |object|
      object.account.image.image_url if object.account.present? and object.account.image.present?
    end
  end
end
