module BxBlockContentmanagement
  class CourseCartsController < ApplicationController

    def create
      course_cart = current_user.course_cart
      if course_cart.present?
        cart_course = course_cart.cart_courses.new(course_id: params[:data][:course_ids][0])
        return render json: { errors: format_activerecord_errors(cart_course.errors) }, status: :unprocessable_entity unless cart_course.save
      else
        course_cart = current_user.build_course_cart(course_cart_params)        
      end
      course_cart.price = course_cart.courses.sum(&:price)

      if course_cart.save
        render json: CourseCartSerializer.new(course_cart).serializable_hash, status: :ok
      else
        render json: {errors: format_activerecord_errors(course_cart.errors)}, status: :unprocessable_entity
      end
    end

    def index
      course_cart = current_user.course_cart
      render json: CourseCartSerializer.new(course_cart).serializable_hash, status: :ok
    end

    private
    def course_cart_params
      params.require(:data).permit \
        course_ids: []
    end
  end
end
