# == Schema Information
#
# Table name: epubs
#
#  id          :bigint           not null, primary key
#  description :text
#  heading     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockContentmanagement
  class Epub < ApplicationRecord
    include Contentable

    self.table_name = :epubs

    validates_presence_of :heading, :description
    has_one :image, as: :attached_item, dependent: :destroy

    has_many :pdfs, as: :attached_item, dependent: :destroy
    accepts_nested_attributes_for :pdfs, allow_destroy: true
    accepts_nested_attributes_for :image, allow_destroy: true

    def name
      heading
    end

    def image_url
      nil
    end

    def video_url
      nil
    end

    def audio_url
      nil
    end

    def study_material_url
      pdfs.first.pdf_url if pdfs.present?
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
        field :image do
          label 'Thumbnail'
          pretty_value do
            if bindings[:object].image.present?
              bindings[:view].tag(:img, { :src => bindings[:object].image.image.url, :class => 'admin_icon' })
            end
          end
        end
        field :pdfs do
          label 'files'
          pretty_value do 
            if bindings[:object].pdfs.present?
              bindings[:view].render partial: 'epub_preview', locals: {files: bindings[:object].pdfs}
            end
          end
        end
        field :created_at
      end
    end

  end
end
