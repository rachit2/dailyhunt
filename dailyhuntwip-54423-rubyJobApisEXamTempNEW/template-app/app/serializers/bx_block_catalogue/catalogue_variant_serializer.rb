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
  class CatalogueVariantSerializer < BuilderBase::BaseSerializer
    attributes :id, :catalogue_id, :catalogue_variant_color_id,
               :catalogue_variant_size_id, :price, :stock_qty, :on_sale,
               :sale_price, :discount_price, :length, :breadth, :height,
               :created_at, :updated_at

    attribute :images do |object, params|
      host = params[:host] || ''

      if object.images.attached?
        object.images.map { |image|
          {
              id: image.id,
              url: host + Rails.application.routes.url_helpers.rails_blob_url(
                image, only_path: true
              )
          }
        }
      end
    end
  end
end
