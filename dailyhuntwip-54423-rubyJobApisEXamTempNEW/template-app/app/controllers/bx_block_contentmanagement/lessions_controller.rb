module BxBlockContentmanagement
  class LessionsController < ApplicationController
    before_action :check_current_partner, only: [:create, :update]
    before_action :get_course, only: [:show, :update]

    def create
      lession = BxBlockContentmanagement::Lession.new(lession_params)
      if lession.save
        render json: LessionSerializer.new(lession).serializable_hash, status: :ok
      else
        render json: {errors: course.errors}
      end
    end

    def update
      if @lession.content_provider == @admin_user
        if @lession.update(course_params)
          render json: LessionSerializer.new(@lession).serializable_hash, status: :ok
        else
          render json: {errors: @lession.errors}, status: :unprocessable_entity
        end
      else
        render json: {error: 'lession not associated with this partner'}, status: :unprocessable_entity
      end
    end

    def show
      render json: LessionSerializer.new(@lession).serializable_hash, status: :ok
    end

    private

    def check_current_partner
      admin_user_id = @token.id
      @admin_user = BxBlockAdmin::AdminUser.partner_user.find_by(id: admin_user_id)
      unless @admin_user.present?
        render json: {error: 'please login with partner'}, status: 404
      end
    end

    def get_course
      @course = BxBlockContentmanagement::Lession.find_by(id: params[:id])
      unless @course
        render json: {error: 'lession not found'}, status: :unprocessable_entity
      end
    end

    def course_params
      params.require(:data).permit \
        :id, 
        :heading, 
        :description, 
        :rank, 
        lession_contents_attributes: [:id, :heading, :description, :rank, :content_type, :duration, :video, :file_content, :_destroy]
    end

  end
end
