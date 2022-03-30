# == Schema Information
#
# Table name: sub_categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#  rank       :integer
#
module BxBlockCategories
  class SubCategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :sub_categories, :rank, :created_at, :updated_at

    attribute :categories, if: Proc.new { |record, params|
      params && params[:categories] == true
    } do |object|
      object.categories&.uniq
    end

    attribute :count do |object, params|
      params[:count][object.id] if params && params[:count]
    end
  end
end
