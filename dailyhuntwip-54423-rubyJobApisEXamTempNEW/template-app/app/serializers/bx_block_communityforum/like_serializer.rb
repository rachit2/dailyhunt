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
  class LikeSerializer < BuilderBase::BaseSerializer
    attributes :id, :likeable_id, :likeable_type, :is_like, :account, :created_at, :updated_at
  end
end
