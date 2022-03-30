# frozen_string_literal: true

module BxBlockContentmanagement
  class ExamsController < ApplicationController

    before_action :assign_exams, only: %i[index show update download_papers create_mock_test mock_tests mock_test get_video assessment all_assessments]
    skip_before_action :validate_json_web_token, only: %i[index show download_papers]
    before_action :check_current_partner, only: %i[create update]

    def create
      exam = BxBlockContentmanagement::Exam.new(exam_params.merge(content_provider: @admin_user))
      if exam.save
        render json: ExamSerializer.new(exam).serializable_hash, status: :ok
      else
        render json: { errors: exam.errors }, status: :unprocessable_entity
      end
    end

    def create_mock_test
      @exam = @exams.find(params[:id])
      mock_test = @exam.mock_tests.new(mock_test_params)
      if mock_test.save
        render json: MockTestSerializer.new(mock_test).serializable_hash, status: :ok
      else
        render json: {errors: mock_test.errors}, status: :unprocessable_entity
      end
    end

    def all_assessments
      @exam = @exams.find(params[:id])
      assessments = @exam.assessments
      render json: BxBlockContentmanagement::AssessmentSerializer.new(assessments.page(params[:page]).per(params[:per_page])).serializable_hash, status: :ok
    end

    def assessment
      @exam = @exams.find(params[:id])
      assessment = @exam.assessments.find(params[:assessment_id])
      if assessment
        render json: BxBlockContentmanagement::AssessmentSerializer.new(assessment).serializable_hash, status: :ok
      else
        render json: { error: 'assessment is not associated with this exam' }, status: :unprocessable_entity
      end

    end

    def mock_tests
      @exam = @exams.find(params[:id])
      mock_tests = @exam.mock_tests
      render json: MockTestSerializer.new(mock_tests.page(params[:page]).per(params[:per_page])).serializable_hash, status: :ok
    end

    def get_video
      @exam = @exams.find(params[:id])
      @video = @exam.content_videos&.find(params[:content_video_id])
      @video.update(view_count: @video.view_count + 1) if @video.present?
      render json:BxBlockContentmanagement::ContentVideoSerializer.new(@video).serializable_hash, status: :ok
    end

    def mock_test
      @exam = @exams.find(params[:id])
      mock_test = @exam.mock_tests.find(params[:mock_test_id])
      if mock_test
        render json: MockTestSerializer.new(mock_test).serializable_hash, status: :ok
      else
        render json: { error: 'mock test is not associated with this exam' }, status: :unprocessable_entity
      end
    end

    def update
      @exam = @exams.find_by(id: params[:id])
      if @exam.content_provider == @admin_user
        if @exam.update(exam_params)
          render json: ExamSerializer.new(@exam).serializable_hash, status: :ok
        else
          render json: { errors: @exam.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: 'exam is not associated with this partner' }, status: :unprocessable_entity
      end
    end

    def index
      filter_exam
      render json: ExamSerializer.new(@exams.page(params[:page]).per(params[:per_page])).serializable_hash, status: :ok
    end

    def show
      @exam = @exams.find_by(id: params[:id])
      render json: ExamSerializer.new(@exam).serializable_hash, status: :ok
    end

    def download_papers
      @exam = @exams.find_by(id: params[:id])
      render json: SamplePaperSerializer.new(@exam).serializable_hash, status: :ok
    end

    private

    def mock_test_params
      params.require(:data).permit \
        :name,
        :description,
        test_questions_attributes: [:id, :question, :options_number, :_destroy, options_attributes: [:id, :answer, :description, :_destroy, :is_right]]
    end

    def exam_params
      params.require(:data).permit(:heading, :description, :start_date, :end_date, :thumbnail, :category_id, :sub_category_id,
                                   exam_updates_attributes: %i[id date update_message link _destroy], exam_sections_attributes: %i[id title body _destroy])
    end

    def check_current_partner
      admin_user_id = @token.id
      @admin_user = BxBlockAdmin::AdminUser.partner_user.find_by(id: admin_user_id)
      render json: { error: 'please login with partner' }, status: 404 unless @admin_user.present?
    end

    def filter_exam
      params.each do |key, value|
        case key
        when 'search'
          search = "%#{value.to_s.downcase}%"
          @exams = @exams.where("lower(heading) LIKE ? or lower(description) LIKE ?", search, search)
        when 'date'
          @exams = @exams.by_dates(value['to'], value['from'])
        when 'current_month'
          @exams = @exams.current_month
        when 'category'
          @exams = @exams.where(category_id: value)
        when 'sub_category'
          @exams = @exams.where(sub_category_id: value)
        when 'is_popular'
          @exams = @exams.popular_exams
        when 'ongoing'
          @exams = @exams.current_month
        when 'tag'
          @exams = @exams.tagged_with(value, any: true)
        when 'content_provider'
          @exams = @exams.where(content_provider_id:value)
        when 'upcoming'
          @exams = @exams.where('start_date > ? OR end_date > ?', Date.today, Date.today)
        end
      end
    end

    def assign_exams
      @exams = BxBlockContentmanagement::Exam.includes(:exam_updates, :exam_sections).order('exam_updates.created_at DESC')
    end
  end
end
