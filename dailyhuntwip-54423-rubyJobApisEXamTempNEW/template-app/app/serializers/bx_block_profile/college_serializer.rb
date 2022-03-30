# frozen_string_literal: true

# == Schema Information
#
# Table name: colleges
#
#  id         :bigint           not null, primary key
#  name       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_others  :boolean          default(FALSE)
#

module BxBlockProfile
  class CollegeSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :is_others, :is_featured, :college_type, :admission_process, :is_popular, :rank, :logo, :brochure, :course_rating,
               :median_salary, :total_fees_max, :total_fees_min, :website_url, :location, :city, :degrees, :courses, :university, :sub_category, :specializations, :created_at, :updated_at

    attribute :logo do |object|
      object.logo if object.logo.present?
    end

    attributes :location do |object|
      LocationSerializer.new(object.location)
    end

    attributes :city do |object|
      CitySerializer.new(object.city)
    end

    attributes :degrees do |object|
      DegreeSerializer.new(object.degrees)
    end

    attributes :university do |object|
      UniversitySerializer.new(object.university)
    end

    attributes :brochure do |object|
      object.brochure.image_url if object.brochure.present?
    end

    attribute :sub_category do |object|
      BxBlockCategories::SubCategorySerializer.new(object.sub_category, params:{categories:true})
    end

  end
end
