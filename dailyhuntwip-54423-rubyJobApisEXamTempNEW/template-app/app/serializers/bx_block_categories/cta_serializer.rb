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
#
# Indexes
#
#  index_cta_on_category_id  (category_id)
#
module BxBlockCategories
  class CtaSerializer < BuilderBase::BaseSerializer
    attributes :id, :headline, :description, :category, :is_square_cta, :is_long_rectangle_cta, :is_text_cta, :is_image_cta, :has_button, :button_text, :redirect_url, :visible_on_details_page, :visible_on_home_page, :text_alignment, :button_alignment, :long_background_image, :square_background_image, :location, :city, :created_at, :updated_at

    attributes :location do |object|
      BxBlockProfile::LocationSerializer.new(object.location)
    end

    attribute :long_background_image do |object|
      object.long_background_image_url
    end

    attributes :city do |object|
      BxBlockProfile::CitySerializer.new(object.city)
    end

    attribute :square_background_image do |object|
      object.square_background_image_url
    end
  end
end
