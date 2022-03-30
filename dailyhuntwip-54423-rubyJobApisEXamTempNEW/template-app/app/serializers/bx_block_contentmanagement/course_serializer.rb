# == Schema Information
#
# Table name: courses
#
#  id                                 :bigint           not null, primary key
#  description                        :text
#  heading                            :string
#  is_popular                         :boolean          default(FALSE)
#  is_premium                         :boolean          default(FALSE)
#  is_trending                        :boolean          default(FALSE)
#  price                              :integer
#  rank                               :integer
#  thumbnail                          :string
#  video                              :string
#  what_you_will_learn_in_this_course :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  category_id                        :bigint
#  content_provider_id                :bigint
#  language_id                        :bigint
#  sub_category_id                    :bigint
#
# Indexes
#
#  index_courses_on_category_id          (category_id)
#  index_courses_on_content_provider_id  (content_provider_id)
#  index_courses_on_language_id          (language_id)
#  index_courses_on_sub_category_id      (sub_category_id)
#
module BxBlockContentmanagement
  class CourseSerializer < BuilderBase::BaseSerializer
    extend ActionView::Helpers::NumberHelper

    attributes :id, :category, :sub_category, :exam, :heading, :description, :what_you_will_learn_in_this_course, :colleges, :enrolled_users, :user_rating, :total_time, :language, :price, :is_popular, :is_free_trailed, :is_trending, :is_premium, :thumbnail, :is_purchased, :video, :available_free_trail, :created_at, :updated_at


    attribute :bookmark do |object, params|
      params && params[:current_user_id] && current_user_bookmark(object, params[:current_user_id])
    end
    attribute :course_analysis do |object, params|
      calculate_course_analysis(object, params[:current_user_id]) if params[:current_user_id].present?
    end
    attribute :language do |object|
      object.language.name
    end
    attribute :is_purchased do |object, params|
      is_ordered(object, params[:paid_courses])
    end
    attribute :enrolled_users do |object|
      object.accounts.count
    end
    attribute :total_time do |object|
      mins = object.lession_contents.pluck(:duration).compact.inject(0, :+)
      "#{mins}min"
    end
    attribute :user_rating do |object|
      (object.ratings&.sum(:rating).to_f / object.ratings.count).round(1) if object.ratings.present?
    end
    attribute :is_free_trailed do |object, params|
      is_freetrailed(object, params[:free_courses])
    end
    attribute :instructors do |object|
      BxBlockContentmanagement::InstructorSerializer.new(object.instructors)
    end
    attribute :content_provider do |object, params|
      BxBlockContentmanagement::ContentProviderSerializer.new(object.content_provider, {params: params})
    end
    attribute :lessions do |object, params|
      BxBlockContentmanagement::LessionSerializer.new(object.lessions, serialization_options(object, params[:paid_courses], params[:free_courses], params[:read_lessions_ids]))
    end
    attribute :ratings do |object|
      BxBlockContentmanagement::RatingSerializer.new(object.ratings)
    end
    attribute :specific_rating do |object|
      ratings = [1,2,3,4,5]
      if object.ratings.present?
        existing_ratings = object.ratings.group_by(&:rating).map{|k,v| [k, v.count]}.to_h
        Hash[(ratings - existing_ratings.keys).map {|x| [x, 0]}].merge(existing_ratings)
      else
      end
    end
    attribute :video do |object|
      object.video_url if object.video.present?
    end
    attribute :thumbnail do |object|
      object.thumbnail_url if object.thumbnail.present?
    end
    attribute :free_trail_remaining_days do |object, params|
      if params[:current_user_id].present?
        trail = Freetrail.find_by(course: object, account: params[:current_user_id])
        trail.created_at+15.days > DateTime.now ?  ((trail.created_at+15.days).to_date - Date.current).to_i : 0 if trail.present?
      end
    end
    attribute :free_trail_end_date do |object, params|
      if params[:current_user_id].present?
        trail = Freetrail.find_by(course: object, account: params[:current_user_id])
        (trail.created_at+15.days).to_date if trail.present?
      end
    end
    class << self
      private

      def serialization_options(object, paid_courses, free_courses, read_lessions_ids)
        options = {}
        options[:params] = { paid: is_ordered(object, paid_courses),
          free_trail: is_freetrailed(object, free_courses),
          read_lessions_ids: read_lessions_ids
        }
        options
      end

      def is_ordered(object, paid_courses)
        paid_courses.pluck(:id).include? object.id if paid_courses.present?
      end

      def is_freetrailed(object, free_courses)
        free_courses.pluck(:id).include? object.id if free_courses.present?
      end

      def current_user_bookmark(object, current_user_id)
        object.bookmarks.where(account_id: current_user_id).present?
      end

      def calculate_course_analysis(object, current_user_id)
        total_lession_contents = object.lession_contents.count
        readed_lession_contents = object.courses_lession_contents.where(account_id: current_user_id).count
        number_with_precision((readed_lession_contents.to_f/total_lession_contents.to_f)*100, precision: 2) if total_lession_contents > 0
      end
    end
  end
end
