module BxBlockContentmanagement
  class HomeCourseSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :category, :sub_category, :description, :what_you_will_learn_in_this_course, :language, :price, :is_popular, :is_trending, :is_premium, :thumbnail, :is_purchased, :video, :created_at, :updated_at
    attribute :language do |object|
      object.language.name
    end
    attribute :is_purchased do |object, params|
      is_ordered(object, params[:courses])
    end
    attribute :instructors do |object|
      BxBlockContentmanagement::InstructorSerializer.new(object.instructors)
    end
    attribute :content_provider_name do |object|
      object.content_provider.partner_name
    end
    attribute :content_provider_id do |object|
      object.content_provider.partner_name
    end
    attribute :ratings do |object|
      object.ratings.sum(:rating)
    end
    attribute :course_duration do |object|
      mins = object.lession_contents.pluck(:duration).map(&:to_time).inject(0) { |sum, t| sum + ((t.hour * 60 + t.min + t.sec / 60).round) }
      "#{mins/60}h #{mins % 60}min"
    end
    attribute :video do |object|
      object.video_url if object.video.present?
    end
    attribute :thumbnail do |object|
      object.thumbnail_url if object.thumbnail.present?
    end
    class << self
      private

      def serialization_options(object, courses)
        options = {}
        options[:params] = { paid: is_ordered(object, courses) }
        options
      end

      def is_ordered(object, courses)
        courses.pluck(:id).include? object.id if courses.present?
      end
    end
  end
end