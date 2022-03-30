module BxBlockContentmanagement
  class CourseOrdersController < ApplicationController

    def create
      course_order = current_user.course_orders.new(course_order_params.merge({status: 'pending'}))
      course_order.order_courses.map{|order_course| order_course.account = current_user}
      total = course_order.courses.sum(&:price)
      course_order.price = total
      if course_order.save
        render json: {order: course_order}, status: :ok
      else
        render json: {errors: course_order.errors}, status: :unprocessable_entity
      end
    end

    def my_courses
      courses = BxBlockContentmanagement::Course.joins(:course_orders).where(course_orders: current_user.course_orders.paid)
      render json: CourseSerializer.new(courses, serialization_options).serializable_hash, status: :ok
    end

    def index
      course_orders = current_user.course_orders
      render json: CourseOrderSerializer.new(course_orders).serializable_hash, status: :ok
    end

    private

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

    def course_order_params
      params.require(:data).permit \
        :status,
        course_ids: []
    end

  end
end
