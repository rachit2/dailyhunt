module BxBlockContentmanagement
  class LessionContentsController < ApplicationController

    def read_lession_contents
      if params[:lessions_content_id].present?
        courses_lession_content = current_user.courses_lession_contents.find_or_create_by(lessions_content_id: params[:lessions_content_id])
        if courses_lession_content.errors.present?
          render json: {error: courses_lession_content.errors}
        else
          render json: { course_lession_content:  courses_lession_content }
        end
      else
        render json: { error: "lession content not found." }
      end
    end
  end
end
