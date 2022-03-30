# == Schema Information
#
# Table name: audio_podcasts
#
#  id          :bigint           not null, primary key
#  description :string
#  heading     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
  class AudioPodcast < ApplicationRecord
  	include Contentable

    self.table_name = :audio_podcasts

    validates_presence_of :heading

    has_one :image, as: :attached_item, dependent: :destroy
    has_one :audio, as: :attached_item, dependent: :destroy

    accepts_nested_attributes_for :image, allow_destroy: true
    accepts_nested_attributes_for :audio, allow_destroy: true

    def name
      heading
    end

    def image_url
      image.image_url if image.present?
    end

    def video_url
      nil
    end

    def audio_url
      audio.audio_url if audio.present?
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

      configure :heading do
        label 'Headline'
      end

      show do
        field :id
        field :heading
        field :description
        field :contentable
        field :image do
          pretty_value do
            label 'Cover Image'
            if bindings[:object].image.present?
              bindings[:view].tag(:img, { :src => bindings[:object].image.image.url, :class => 'admin_icon' })
            end
          end
        end
        field :audio do
          pretty_value do
            label 'Audio'
            if bindings[:object].audio.present?
              bindings[:view].tag(:video, { :src => bindings[:object].audio.audio.url, :controls => true })
            end
          end
        end
        field :created_at
      end
    end
  end

end
