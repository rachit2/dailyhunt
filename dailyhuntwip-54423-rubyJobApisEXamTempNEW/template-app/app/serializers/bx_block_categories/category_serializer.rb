# == Schema Information
#
# Table name: categories
#
#  id                  :bigint           not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  admin_user_id       :integer
#  rank                :integer
#  light_icon          :string
#  light_icon_active   :string
#  light_icon_inactive :string
#  dark_icon           :string
#  dark_icon_active    :string
#  dark_icon_inactive  :string
#  identifier          :integer
#
module BxBlockCategories
  class CategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :dark_icon, :dark_icon_active,  :dark_icon_inactive, :light_icon, :light_icon_active, :light_icon_inactive, :rank, :created_at, :updated_at

    attribute :dark_icon do |object|
      object.dark_icon_url
    end

    attribute :dark_icon_active do |object|
      object.dark_icon_active_url
    end

    attribute :dark_icon_inactive do |object|
      object.dark_icon_inactive_url
    end

    attribute :light_icon do |object|
      object.light_icon_url
    end

    attribute :light_icon_active do |object|
      object.light_icon_active_url
    end

    attribute :light_icon_inactive do |object|
      object.light_icon_inactive_url
    end

    attribute :sub_categories, if: Proc.new { |record, params|
      params && params[:sub_categories] == true
    } do |object, params|
      object.sub_categories&.uniq
    end

    attribute :selected_sub_categories do |object, params|
      if params[:selected_sub_categories].present?
        object.sub_categories.where(id: params[:selected_sub_categories])
      end
    end

    attribute :count do |object, params|
      params[:count][object.id] if params && params[:count]
    end
  end
end
