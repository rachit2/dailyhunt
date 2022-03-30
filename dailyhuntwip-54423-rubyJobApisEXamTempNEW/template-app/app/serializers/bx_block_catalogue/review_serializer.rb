# == Schema Information
#
# Table name: reviews
#
#  id           :bigint           not null, primary key
#  comment      :string
#  rating       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  catalogue_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_catalogue_id  (catalogue_id)
#
# Foreign Keys
#
#  fk_rails_...  (catalogue_id => catalogues.id)
#
module BxBlockCatalogue
  class ReviewSerializer < BuilderBase::BaseSerializer
    attributes :id, :catalogue_id, :rating, :comment, :created_at, :updated_at
  end
end
