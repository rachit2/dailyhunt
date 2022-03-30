module BxBlockContentmanagement
  class CoursesController < ApplicationController
    before_action :assign_courses, only: [:index, :home_courses]
    skip_before_action :validate_json_web_token, only: [:index, :home_courses, :show, :bought_courses]
    before_action :check_current_partner, only: [:create, :update]
    before_action :get_course, only: [:show, :update, :bought_courses, :ratings]
    before_action :check_paid_course, only: [:ratings]
    before_action :validate_email, only: [:free_trail]
    before_action :validate_phone, only: [:free_trail]

    def create
      course = BxBlockContentmanagement::Course.new(course_params.merge(content_provider: @admin_user))
      if course.save
        render json: CourseSerializer.new(course).serializable_hash, status: :ok
      else
        render json: {errors: course.errors}, status: :unprocessable_entity
      end
    end

    def bought_courses
      courses = Course.joins(:accounts).where(accounts: {id: @course.accounts}).page(params[:page]).per(params[:per_page]).distinct
      render json: CourseSerializer.new(courses, serialization_options).serializable_hash, status: :ok
    end

    def recommended_courses
      courses = BxBlockContentmanagement::Course.joins(:category).where(category: current_user.categories).page(params[:page]).per(params[:per_page])
      render json: CourseSerializer.new(courses, serialization_options).serializable_hash, status: :ok
    end

    def shotlist_courses
      courses = current_user.course_followings
      render json: CourseSerializer.new(courses, serialization_options).serializable_hash, status: :ok
    end

    def ratings
      rating = @course.ratings.new(rating_params.merge(account: current_user))
      if rating.save
        render json: RatingSerializer.new(rating).serializable_hash, status: :ok
      else
        render json: {errors: rating.errors}, status: :unprocessable_entity
      end
    end

    def free_trail
      free_trail = BxBlockContentmanagement::Freetrail.new(free_trail_params.merge(account: current_user))
      if free_trail.save
        render json: {message: 'free trail activated'}, status: :ok
      else
        render json: {errors: free_trail.errors}, status: :unprocessable_entity
      end
    end

    def free_trails
      freetrails = current_user.freetrails.where("created_at > ?",  DateTime.now-15.days)
      render json: CourseSerializer.new(Course.where(id: freetrails.pluck(:course_id)), serialization_options).serializable_hash, status: :ok
    end

    def index
      filter_courses
      if params[:search].present?
        @courses = @courses.where("courses.heading LIKE ? or courses.description LIKE ? ", "%#{params[:search]}%", "%#{params[:search]}%")
      end
      @courses = @courses.page(params[:page]).per(params[:per_page])
      render json: CourseSerializer.new(@courses, serialization_options).serializable_hash.merge(total_pages: @courses.total_pages), status: :ok
    end

    def home_courses
      filter_courses
      data =  [
            {title: 'popular', list: HomeCourseSerializer.new(@courses.where(is_popular: true), serialization_options)},
            {title: 'premium', list: HomeCourseSerializer.new(@courses.where(is_premium: true), serialization_options)},
            {title: 'trending', list: HomeCourseSerializer.new(@courses.where(is_trending: true), serialization_options)}
          ]
      render :json => {data: data}, status: :ok
    end

    def update
      if @course.content_provider == @admin_user
        if @course.update(course_params)
          render json: CourseSerializer.new(@course).serializable_hash, status: :ok
        else
          render json: {errors: @course.errors}, status: :unprocessable_entity
        end
      else
        render json: {error: 'course not associated with this partner'}, status: :unprocessable_entity
      end
    end

    def show
      render json: CourseSerializer.new(@course, serialization_options).serializable_hash, status: :ok
    end

    private

    def check_current_partner
      admin_user_id = @token.id
      @admin_user = BxBlockAdmin::AdminUser.partner_user.find_by(id: admin_user_id)
      unless @admin_user.present?
        render json: {error: 'please login with partner'}, status: 404
      end
    end

    def assign_courses
      @courses = BxBlockContentmanagement::Course.includes(:lessions, :content_provider, :ratings, :language, :instructors, :lession_contents)
    end

    def validate_email
      render json: {error: 'Email not varified.'}, status: :unprocessable_entity unless current_user.email_verified
    end

    def validate_phone
        render json: {error: 'phone not varified.'}, status: :unprocessable_entity unless current_user.phone_verified
    end

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { paid_courses: (BxBlockContentmanagement::Course.joins(:course_orders).where(course_orders: current_user&.course_orders&.paid)),
        free_courses: (current_user&.freetrails_courses),
        current_user_id: (current_user&.id),
        read_lessions_ids: (current_user&.courses_lession_contents&.pluck(:lessions_content_id))
      }
      options
    end

    def filter_courses
      params.each do |key, value|
        case key
        when 'category'
          @courses = @courses.where(category_id: value)
        when 'sub_category'
          @courses = @courses.where(sub_category_id: value)
        when 'content_provider'
          @courses = @courses.where(content_provider_id: value)
        when 'exam'
          @courses = @courses.where(exam_id: value)
        when 'rating'
          @courses = @courses.where(ratings: {rating: value})
        when 'price'
          @courses = @courses.where("price <= ?", value)
        when 'language'
          @courses = @courses.where(language_id: value)
        when 'is_popular'
          @courses = @courses.where(is_popular: true)
        when 'is_trending'
          @courses = @courses.where(is_trending: true)
        when 'is_premium'
          @courses = @courses.where(is_premium: true)
        when 'instructor'
          @courses = @courses.where(instructors: {id: value})
        when 'new_courses'
          @courses = @courses.order(created_at: :desc)
        end
      end
    end

    def get_course
      @course = BxBlockContentmanagement::Course.find_by(id: params[:id])
      unless @course
        render json: {error: 'course not found'}, status: :unprocessable_entity
      end
    end

    def course_params
      params.require(:data).permit \
        :heading,
        :description,
        :language_id,
        :price,
        :instructor_id,
        :is_popular,
        :is_trending,
        :is_premium,
        :thumbnail,
        :video,
        :category_id,
        :sub_category_id,
        :exam_id,
        lessions_attributes: [:id, :heading, :description, :rank, :_destroy, lession_contents_attributes: [:id, :heading, :description, :rank, :content_type, :duration, :video, :file_content, :_destroy]]
    end

    def rating_params
      params.require(:data).permit \
        :rating,
        :review
    end

    def order_params
      params.require(:data).permit \
        :status,
        course_ids: []
    end

    def check_paid_course
      @course = BxBlockContentmanagement::Course.joins(:course_orders).where(course_orders: current_user.course_orders.paid, courses: {id: params[:id]}).first
      unless @course.present?
        render json: {error: 'you are not allowed to rate this.'}, status: :unprocessable_entity
      end
    end

    def free_trail_params
      params.require(:data).permit \
        :course_id
    end

  end
end
