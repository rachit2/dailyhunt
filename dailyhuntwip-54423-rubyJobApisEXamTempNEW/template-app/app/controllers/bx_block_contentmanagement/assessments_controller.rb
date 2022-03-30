module BxBlockContentmanagement
  class AssessmentsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:show, :index, :destroy, :assessments]
    before_action :assign_json_web_token, only: [:index]
    before_action :set_assessment, only: [:show, :update, :create_question, :update_question, :assessment_answers]
    before_action :check_current_partner, only: [:create, :update, :destroy, :create_question, :update_question]
    before_action :check_content_provider, only: [:update, :create_question, :update_question]

    def show
      render json: AssessmentSerializer.new(@assessment).serializable_hash, status: :ok
    end

    def index
      @assessments = BxBlockContentmanagement::Assessment.all.page(params[:page]).per(params[:per_page])
      filter_assessments
      render json: AssessmentSerializer.new(@assessments).serializable_hash, status: :ok
    end

    def assessments
      assessments = BxBlockContentmanagement::Assessment.all
      data =  [
            {title: 'popular', list: AssessmentSerializer.new(assessments.where(is_popular: true))},
            {title: 'trending', list: AssessmentSerializer.new(assessments.where(is_trending: true))}
          ]
      render :json => {data: data}, status: :ok
    end

    def create
      assessment = BxBlockContentmanagement::Assessment.new(assessment_params.merge(content_provider: @admin_user))
      if assessment.save
        render json: AssessmentSerializer.new(assessment).serializable_hash, status: :created
      else
        render json: {errors: assessment.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      if @assessment.destroy
        render json: { success: true }, status: :ok
      else
        render json: ErrorSerializer.new(@assessment).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def update
      if @assessment.content_provider == @admin_user
        if @assessment.update(assessment_params)
          render json: AssessmentSerializer.new(@assessment).serializable_hash, status: :ok
        else
          render json: {errors: @assessment.errors}, status: :unprocessable_entity
        end
      else
        render json: {error: 'Assessment not associated with this partner'}, status: :unprocessable_entity
      end
    end

    def my_assessments
      render json: AssessmentSerializer.new(@admin_user.assessments).serializable_hash, status: :ok
    end

    def create_question
      test_question = @assessment.test_questions.new(test_question_params)
      if test_question.save
        render json: TestQuestionSerializer.new(test_question).serializable_hash, status: :ok
      else
        render json: {errors: test_question.errors}, status: :unprocessable_entity
      end
    end

    def update_question
      test_question = @assessment.test_questions.find(params[:test_question_id])
      if test_question.update(test_question_params)
        render json: TestQuestionSerializer.new(test_question).serializable_hash, status: :ok
      else
        render json: {errors: test_question.errors}, status: :unprocessable_entity
      end
    end

    def assessment_answers
      test_questions = @assessment.test_questions
      render json: TestQuestionSerializer.new(test_questions, serialization_options).serializable_hash, status: :ok
    end

    private

    def serialization_options
      options = {}
      options[:params] = { current_user_id: (current_user.id) }
      options
    end

    def set_assessment
      @assessment = BxBlockContentmanagement::Assessment.find(params[:id])
    end

    def assessment_params
      params.require(:data).permit \
        :heading,
        :description,
        :timer,
        :language_id,
        :exam_id,
        :category_id,
        :sub_category_id,
        :is_popular,
        :is_trending,
        test_questions_attributes: [:id, :question, :options_number, :_destroy, options_attributes: [:id, :answer, :description, :is_right]]
    end

    def test_question_params
      params.require(:data).permit \
        :id,
        :question,
        :options_number,
        options_attributes: [:id, :answer, :description, :is_right, :_destroy]
    end

    def check_content_provider
      unless @assessment.content_provider == @admin_user
        render json: {error: 'assessment not associated with this partner'}, status: :unprocessable_entity
      end
    end

    def filter_assessments
      params.each do |key, value|
        case key
        when 'category'
          @assessments = @assessments.where(category_id: value)
        when 'sub_category'
          @assessments = @assessments.where(sub_category_id: value)
        when 'is_popular'
          @assessments = @assessments.where(is_popular: value)
        when 'is_trending'
          @assessments = @assessments.where(is_trending: value)
        when 'is_recommended'
          @assessments = @assessments.where(category: current_user&.categories)
        end
      end
    end
  end
end
