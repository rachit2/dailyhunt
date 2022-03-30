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
  class CatalogueVariantColor < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogue_variant_colors
  end
end
