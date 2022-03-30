class BxBlockContentmanagement::MockTestController < ApplicationController

  skip_before_action :validate_json_web_token, only: [:index, :show]
  before_action :assign_json_web_token, only: [:index]
  before_action :get_mock_test, only: [:show, :update, :create_question, :update_question]

  def index
    @mock_tests = BxBlockContentmanagement::MockTest.page(params[:page]).per(params[:per_page])
    @mock_tests = @mock_tests.where('name ILIKE :search or description ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    render json: { data: BxBlockContentmanagement::MockTestSerializer.new(@mock_tests, serialization_options).serializable_hash, total_pages: @mock_tests.total_pages }, status: :ok
  end

  def create
    mock_test = @admin_user.mock_tests.new(mock_test_params)
    if mock_test.save
      render json: MockTestSerializer.new(mock_test).serializable_hash, status: :ok
    else
      render json: {errors: mock_test.errors}, status: :unprocessable_entity
    end
  end

  def create_question
    test_question = @mock_test.test_questions.new(test_question_params)
    if test_question.save
      render json: TestQuestionSerializer.new(test_question).serializable_hash, status: :ok
    else
      render json: {errors: test_question.errors}, status: :unprocessable_entity
    end
  end

  def show
    render json: BxBlockContentmanagement::MockTestSerializer.new(@mock_test).serializable_hash, status: :ok
  end

  private

  def serialization_options
    options = {}
    options[:params] = { current_user_id: (current_user&.id) }
    options
  end

  def quiz_params
    params.require(:data).permit \
      :name,
      :description,
      :exam_id,
      test_questions_attributes: [:id, :question, :options_number, :_destroy, options_attributes: [:id, :answer, :description, :_destroy, :is_right]]
  end

  def test_question_params
    params.require(:data).permit \
      :id,
      :question,
      :options_number,
      options_attributes: [:id, :answer, :description, :is_right, :_destroy]
  end

  def get_mock_test
    @mock_test = BxBlockContentmanagement::MockTest.find_by(id: params[:id])
    unless @mock_test
      render json: {error: 'mock_test not found'}, status: :unprocessable_entity
    end
  end


end
