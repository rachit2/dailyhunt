# == Schema Information
#
# Table name: catalogue_variant_colors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockCatalogue
  class CatalogueVariantColorSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :created_at, :updated_at
  end
end
