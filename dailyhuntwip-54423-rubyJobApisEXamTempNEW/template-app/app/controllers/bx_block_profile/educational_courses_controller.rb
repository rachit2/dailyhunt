module BxBlockProfile
  class EducationalCoursesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      educational_courses = BxBlockProfile::EducationalCourse.all.order(:rank)
      render json: BxBlockProfile::EducationalCourseSerializer.new(educational_courses).serializable_hash, status: :ok
    end
  end
end
