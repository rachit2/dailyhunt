module BxBlockContentmanagement
  class UserAssessmentsController < ApplicationController

    def index
      render json: UserAssessmentSerializer.new(current_user.user_assessments).serializable_hash, status: :ok
    end

    def create
      destroy_assessment = current_user.user_assessments.find_by(assessment_id: params[:assessment_id])
      attempt_count = destroy_assessment&.attempt_count || 0
      destroy_assessment.destroy if destroy_assessment.present?

      user_assessment = current_user.user_assessments.new(assessment_id: params[:assessment_id], attempt_count: attempt_count + 1)
      if user_assessment.save
        render json: UserAssessmentSerializer.new(user_assessment).serializable_hash, status: :ok
      else
        render json: {errors: user_assessment.errors}, status: :unprocessable_entity
      end
    end


    #user give answer to the question
    def user_option
      user_assessment = current_user.user_assessments.find_by(assessment_id: params[:assessment_id])
      if user_assessment.present?
        user_option = user_assessment.user_options.new(option_params)
        user_option.is_true = user_option.option.is_right
        if user_option.save
          render json: UserOptionSerializer.new(user_option).serializable_hash, status: :ok
        else
          render json: {errors: user_option.errors}, status: :unprocessable_entity
        end
      else
        render json: {error: 'User Assessment with this assessment id does not found'}, status: :unprocessable_entity
      end  
    end

    def update_option
      user_option = UserOption.find(params[:user_option_id])
      user_option.is_true = Option.find(params[:data][:option_id]).is_right
      if user_option.update(option_params)
        render json: UserOptionSerializer.new(user_option).serializable_hash, status: :ok
      else
        render json: {errors: user_option.errors}, status: :unprocessable_entity
      end
    end

    def my_score
      user_assessment = current_user.user_assessments.find_by(assessment_id: params[:assessment_id])
      render json: UserAssessmentSerializer.new(user_assessment).serializable_hash, status: :ok
    end

    private

    def option_params
      params.require(:data).permit(:test_question_id, :option_id)
    end
  end
end
