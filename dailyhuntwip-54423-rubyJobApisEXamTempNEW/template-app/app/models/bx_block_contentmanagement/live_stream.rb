# == Schema Information
#
# Table name: live_streams
#
#  id          :bigint           not null, primary key
#  description :string
#  headline    :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
  class LiveStream < ApplicationRecord
  	include Contentable

    self.table_name = :live_streams

    validates_presence_of :headline, :url
    has_one :image, as: :attached_item, dependent: :destroy
    accepts_nested_attributes_for :image, allow_destroy: true

    def name
      headline
    end

    def image_url
      image.image_url if image.present?
    end

    def video_url
      nil
    end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end

    rails_admin do
      configure :description do
        pretty_value do
          value.html_safe
        end
      end

      show do
        field :id
        field :headline
        field :description
        field :contentable
        field :image do
          label 'Thumbnail'
          pretty_value do
            if bindings[:object].image.present?
              bindings[:view].tag(:img, { :src => bindings[:object].image.image.url, :class => 'admin_icon' })
            end
          end
        end
        field :url
        field :created_at
      end
    end
  end
end
