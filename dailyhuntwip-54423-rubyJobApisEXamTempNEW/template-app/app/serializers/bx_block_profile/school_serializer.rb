# frozen_string_literal: true

module BxBlockProfile
  class SchoolSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :is_featured, :is_popular, :rank, :course_rating, :logo, :brochure, :website_url, :board,
               :school_type, :language_of_interaction, :admission_process, :median_salary, :total_fees_min, :total_fees_max, :standards, :location, :city, :created_at, :updated_at

    attribute :logo do |object|
      object.logo if object.logo.present?
    end

    attributes :brochure do |object|
      object.brochure.image_url if object.brochure.present?
    end

    attributes :board do |object|
      BoardSerializer.new(object.board)
    end

    attributes :standards do |object|
      StandardSerializer.new(object.standards)
    end

    attributes :location do |object|
      LocationSerializer.new(object.location)
    end

    attributes :city do |object|
      CitySerializer.new(object.city)
    end
  end
end
