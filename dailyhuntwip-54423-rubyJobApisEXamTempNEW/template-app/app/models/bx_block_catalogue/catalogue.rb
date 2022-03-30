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
  class Catalogue < BxBlockCatalogue::ApplicationRecord
    PAGE = 1
    PER_PAGE = 10

    self.table_name = :catalogues

    enum availability: %i[in_stock out_of_stock]

    belongs_to :category,
               class_name: 'BxBlockCategories::Category',
               foreign_key: 'category_id'

    belongs_to :sub_category,
               class_name: 'BxBlockCategories::SubCategory',
               foreign_key: 'sub_category_id'

    belongs_to :brand, optional: true

    has_many :reviews, dependent: :destroy
    has_many :catalogue_variants, dependent: :destroy
    has_and_belongs_to_many :tags, join_table: :catalogues_tags

    has_many_attached :images, dependent: :destroy

    accepts_nested_attributes_for :catalogue_variants, allow_destroy: true

    def average_rating
      return 0 if reviews.size.zero?

      total_rating = 0
      reviews.each do |r|
        total_rating += r.rating
      end
      total_rating.to_f / reviews.size.to_f
    end
  end
end

