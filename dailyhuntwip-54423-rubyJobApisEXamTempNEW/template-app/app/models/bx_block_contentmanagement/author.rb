# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockContentmanagement
  class Author < ApplicationRecord
    self.table_name = :authors
    has_many :contents, class_name: "BxBlockContentmanagement::Content", dependent: :destroy
    validates :name, :bio, presence: true
    validates :bio, :length => {
      :maximum   => 500, :too_long  => "should not greater then %{count} words"
    }
    has_one :image, as: :attached_item, dependent: :destroy

    accepts_nested_attributes_for :image, allow_destroy: true

    rails_admin do
      show do
        field :id
        field :name
        field :bio
        field :image do
          pretty_value do
            if bindings[:object].image.present?
              bindings[:view].tag(:img, { :src => bindings[:object].image.image.url, :class => 'admin_icon' })
            end
          end
        end
        field :created_at
      end
    end
  end
end
