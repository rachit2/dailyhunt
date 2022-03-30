# == Schema Information
#
# Table name: catalogue_variants
#
#  id                         :bigint           not null, primary key
#  block_qty                  :integer
#  breadth                    :float
#  discount_price             :decimal(, )
#  height                     :float
#  length                     :float
#  on_sale                    :boolean
#  price                      :decimal(, )
#  sale_price                 :decimal(, )
#  stock_qty                  :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  catalogue_id               :bigint           not null
#  catalogue_variant_color_id :bigint
#  catalogue_variant_size_id  :bigint
#
# Indexes
#
#  index_catalogue_variants_on_catalogue_id                (catalogue_id)
#  index_catalogue_variants_on_catalogue_variant_color_id  (catalogue_variant_color_id)
#  index_catalogue_variants_on_catalogue_variant_size_id   (catalogue_variant_size_id)
#
# Foreign Keys
#
#  fk_rails_...  (catalogue_id => catalogues.id)
#  fk_rails_...  (catalogue_variant_color_id => catalogue_variant_colors.id)
#  fk_rails_...  (catalogue_variant_size_id => catalogue_variant_sizes.id)
#
module BxBlockCatalogue
  class CatalogueVariant < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogue_variants

    belongs_to :catalogue
    belongs_to :catalogue_variant_color, optional: true
    belongs_to :catalogue_variant_size, optional: true

    has_many_attached :images, dependent: :destroy
  end
end
