# == Schema Information
#
# Table name: catalogues
#
#  id               :bigint           not null, primary key
#  availability     :integer
#  block_qty        :integer
#  breadth          :float
#  description      :string
#  discount         :decimal(, )
#  height           :float
#  length           :float
#  manufacture_date :datetime
#  name             :string
#  on_sale          :boolean
#  price            :float
#  recommended      :boolean
#  sale_price       :decimal(, )
#  sku              :string
#  stock_qty        :integer
#  weight           :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  brand_id         :bigint
#  category_id      :bigint           not null
#  sub_category_id  :bigint           not null
#
# Indexes
#
#  index_catalogues_on_brand_id         (brand_id)
#  index_catalogues_on_category_id      (category_id)
#  index_catalogues_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (sub_category_id => sub_categories.id)
#
module BxBlockCatalogue
  class CatalogueSerializer < BuilderBase::BaseSerializer
    attributes :category, :sub_category, :brand, :tags, :reviews,
               :name, :sku, :description, :manufacture_date,
               :length, :breadth, :height, :stock_qty,
               :availability, :weight, :price, :recommended,
               :on_sale, :sale_price, :discount

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

    attribute :average_rating, &:average_rating

    attribute :catalogue_variants do |object, params|
      serializer = CatalogueVariantSerializer.new(
        object.catalogue_variants, { params: params }
      )
      serializer.serializable_hash[:data]
    end
  end
end
