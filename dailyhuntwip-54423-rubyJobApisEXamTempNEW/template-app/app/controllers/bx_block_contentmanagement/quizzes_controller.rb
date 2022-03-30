module BxBlockContentmanagement
  class QuizzesController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index, :home_quizzes, :show, :explore]
    before_action :assign_json_web_token, only: [:index]
    before_action :check_current_partner, only: [:create, :update, :myquizzes, :create_question, :update_question]
    before_action :get_quiz, only: [:show, :update, :create_question, :update_question]
    before_action :check_content_provider, only: [:update, :create_question, :update_question]

    def index
      @quizzes = BxBlockContentmanagement::Quiz.page(params[:page]).per(params[:per_page])
      @quizzes = @quizzes.where('heading ILIKE :search or description ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
      filter_quizzes
      render json: { data: BxBlockContentmanagement::QuizSerializer.new(@quizzes, serialization_options).serializable_hash, total_pages: @quizzes.total_pages }, status: :ok
    end

    def explore
      quizzes = Quiz.page(params[:page]).per(3)
      assessments = Assessment.page(params[:page]).per(3)
      quizzes_serializer = QuizSerializer.new(quizzes).serializable_hash
      assessments_serializer = AssessmentSerializer.new(assessments).serializable_hash
      data = quizzes.count > assessments.count ? quizzes_serializer[:data].zip(assessments_serializer[:data]).flatten : assessments_serializer[:data].zip(quizzes_serializer[:data]).flatten
      total_pages = quizzes.total_pages > assessments.total_pages ? quizzes.total_pages : assessments.total_pages
      render json: {data: data.reject(&:blank?), total_pages: total_pages}, status: :ok
    end

    def create
      quiz = @admin_user.quizzes.new(quiz_params)
      if quiz.save
        render json: QuizSerializer.new(quiz).serializable_hash, status: :ok
      else
        render json: {errors: quiz.errors}, status: :unprocessable_entity
      end
    end

    def create_question
      test_question = @quiz.test_questions.new(test_question_params)
      if test_question.save
        render json: TestQuestionSerializer.new(test_question).serializable_hash, status: :ok
      else
        render json: {errors: test_question.errors}, status: :unprocessable_entity
      end
    end

    def update_question
      test_question = @quiz.test_questions.find(params[:test_question_id])
      if test_question.update(test_question_params)
        render json: TestQuestionSerializer.new(test_question).serializable_hash, status: :ok
      else
        render json: {errors: test_question.errors}, status: :unprocessable_entity
      end
    end

    def myquizzes
      render json: QuizSerializer.new(@admin_user.quizzes).serializable_hash, status: :ok
    end

    def update
      if @quiz.update(quiz_params)
        render json: QuizSerializer.new(@quiz).serializable_hash, status: :ok
      else
        render json: {errors: @quiz.errors}, status: :unprocessable_entity
      end
    end

    def home_quizzes
      quizzes = BxBlockContentmanagement::Quiz.all
      data =  [
            {title: 'popular', list: QuizSerializer.new(quizzes.where(is_popular: true))},
            {title: 'trending', list: QuizSerializer.new(quizzes.where(is_trending: true))}
          ]
      render :json => {data: data}, status: :ok
    end

    def show
      render json: BxBlockContentmanagement::QuizSerializer.new(@quiz).serializable_hash, status: :ok
    end

    private

    def serialization_options
      options = {}
      options[:params] = { current_user_id: (current_user&.id) }
      options
    end

    def quiz_params
      params.require(:data).permit \
        :heading,
        :description,
        :timer,
        :category_id,
        :sub_category_id,
        :language_id,
        :is_popular,
        :is_trending,
        :quiz_description,
        test_questions_attributes: [:id, :question, :options_number, :_destroy, options_attributes: [:id, :answer, :description, :_destroy, :is_right]]
    end

    def test_question_params
      params.require(:data).permit \
        :id,
        :question,
        :options_number,
        options_attributes: [:id, :answer, :description, :is_right, :_destroy]
    end

    def get_quiz
      @quiz = BxBlockContentmanagement::Quiz.find_by(id: params[:id])
      unless @quiz
        render json: {error: 'quiz not found'}, status: :unprocessable_entity
      end
    end

    def check_content_provider
      unless @quiz.content_provider == @admin_user
        render json: {error: 'quiz not associated with this partner'}, status: :unprocessable_entity
      end
    end

    def filter_quizzes
      params.each do |key, value|
        case key
        when 'category'
          @quizzes = @quizzes.where(category_id: value)
        when 'sub_category'
          @quizzes = @quizzes.where(sub_category_id: value)
        when 'is_popular'
          @quizzes = @quizzes.where(is_popular: value)
        when 'is_trending'
          @quizzes = @quizzes.where(is_trending: value)
        when 'is_recommended'
          @quizzes = @quizzes.where(category: current_user&.categories)  
        end
      end
    end
  end
end
