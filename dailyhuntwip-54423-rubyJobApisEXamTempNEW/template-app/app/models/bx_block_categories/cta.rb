# == Schema Information
#
# Table name: cta
#
#  id                      :bigint           not null, primary key
#  button_alignment        :integer
#  button_text             :string
#  description             :text
#  has_button              :boolean
#  headline                :string
#  is_image_cta            :boolean
#  is_long_rectangle_cta   :boolean
#  is_square_cta           :boolean
#  is_text_cta             :boolean
#  long_background_image   :string
#  redirect_url            :string
#  square_background_image :string
#  text_alignment          :integer
#  visible_on_details_page :boolean
#  visible_on_home_page    :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  category_id             :bigint
#  city_id                 :bigint
#  location_id             :bigint
#
# Indexes
#
#  index_cta_on_category_id  (category_id)
#  index_cta_on_city_id      (city_id)
#  index_cta_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (location_id => locations.id)
#
module BxBlockCategories
  class Cta < ApplicationRecord
    self.table_name = :cta
    belongs_to :category
    mount_uploader :long_background_image, ImageUploader
    mount_uploader :square_background_image, ImageUploader
    belongs_to :location, class_name:"BxBlockProfile::Location", optional: true
    belongs_to :city, class_name:"BxBlockProfile::City", optional: true

    enum text_alignment: ["centre", "left", "right"]
    enum button_alignment: ["centre", "left", "right"], _suffix: true

    validates :headline, :text_alignment, presence: true, if: -> { self.is_text_cta }
    validates :button_text, :redirect_url, :button_alignment, presence: true, if: -> { self.has_button }
    validates :square_background_image, presence: true, if: -> { self.is_image_cta && self.is_square_cta }
    validates :long_background_image, presence: true, if: -> { self.is_image_cta && self.is_long_rectangle_cta }
    after_validation :validate_city, if: -> {self.city_id}

    def name
      headline
    end

    def validate_city
      if !(location&.id)
        errors.add(:location, "Must exist for the city")
        false
      elsif !(location_id == city.location_id)
        errors.add(:city, "Must choose a city under #{location.name}")
        false
      end
    end


    rails_admin do
      list do
        field :id
        field :headline
        field :description
        field :category
        field :is_square_cta
        field :is_long_rectangle_cta
        field :is_text_cta
        field :is_image_cta
        field :location
        field :city
        field :has_button
        field :button_text
        field :redirect_url
        field :visible_on_details_page
        field :visible_on_home_page
        field :text_alignment
        field :button_alignment
        field :long_background_image, :carrierwave
        field :square_background_image, :carrierwave

        field :created_at do
          label 'Created'
        end
        field :updated_at do
          label 'Updated'
        end
      end

      show do
        field :id
        field :headline
        field :description
        field :category
        field :is_square_cta
        field :is_long_rectangle_cta
        field :is_text_cta
        field :is_image_cta
        field :has_button
        field :button_text
        field :redirect_url
        field :visible_on_details_page
        field :visible_on_home_page
        field :text_alignment
        field :button_alignment
        field :long_background_image, :carrierwave
        field :square_background_image, :carrierwave

        field :created_at do
          label 'Created'
        end
        field :updated_at do
          label 'Updated'
        end
      end

      edit do
        field :headline
        field :is_text_cta
        field :text_alignment
        field :location
        field :city
        field :description
        field :category
        field :is_image_cta
        field :is_square_cta
        field :square_background_image, :carrierwave
        field :is_long_rectangle_cta
        field :long_background_image, :carrierwave
        field :has_button
        field :button_text
        field :redirect_url
        field :button_alignment
        field :visible_on_details_page
        field :visible_on_home_page
      end
    end
  end
end
