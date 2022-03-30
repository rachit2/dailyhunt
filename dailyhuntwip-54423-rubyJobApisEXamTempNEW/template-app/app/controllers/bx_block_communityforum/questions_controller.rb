module BxBlockCommunityforum
  class QuestionsController < ApplicationController
    before_action :assign_questions, only: [:index, :show, :update, :destroy, :my_questions]
    before_action :assign_json_web_token, only: [:index]
    skip_before_action :validate_json_web_token, only: [:show, :index, :feed_questions, :details]
    before_action :set_account, only: [:details]

    def show
      question = @questions.find(params[:id])

      question.update(view: question.view + 1) if question.present?
      render json: QuestionSerializer.new(question, serialization_options).serializable_hash, status: :ok
    end

    def destroy
      question = @questions.find(params[:id])

      if question.account != current_user
        render json: {error: "Not authorized."}, status: :unprocessable_entity
      else
        question.destroy
        render json: {message: 'question deleted'}, status: :ok
      end
    end

    def my_questions
      @questions = current_user.questions
      filter_question
      questions = search_questions.order(updated_at: :desc)
      render json: QuestionSerializer.new(questions, serialization_options).serializable_hash, status: :ok
    end

    def drafted_questions
      @questions = current_user.questions.draft
      filter_question
      questions = search_questions.order(updated_at: :desc)
      render json: QuestionSerializer.new(questions).serializable_hash, status: :ok
    end

    def published_questions
      @questions = current_user.questions.publish
      filter_question
      questions = search_questions.order(updated_at: :desc)
      render json: QuestionSerializer.new(questions).serializable_hash, status: :ok
    end

    def details
      render json: {question_asked: @account.questions.count, question_drafted: @account.questions.total_drafted, answered_questions: @account.comments.count, question_pending: 0}, status: :ok
    end

    def feed_questions
      assign_json_web_token
      questions = Question.all
      data =  [
            {title: 'popular', list: QuestionSerializer.new(questions.where(is_popular: true))},
            {title: 'trending', list: QuestionSerializer.new(questions.where(is_trending: true))},
            {title: 'recommended_questions', list: QuestionSerializer.new(questions.where(sub_category: current_user&.categories&.pluck(:id)))}
          ]
      render :json => {data: data}, status: :ok
    end

    def index
      filter_question
      questions = search_questions
      render json: QuestionSerializer.new(questions, serialization_options).serializable_hash, status: :ok
    end

    def create
      if params[:question].present? and params[:question][:sub_category_id].present?
        question = current_user.questions.new(question_params)

        if question.save
          render json: QuestionSerializer.new(question).serializable_hash,
                 status: :created
        else
          render json: ErrorSerializer.new(question).serializable_hash,
                 status: :unprocessable_entity
        end
      else
        render json: {error: "Sub Category not found"}, status: :unprocessable_entity
      end
    end

     def update
      question = @questions.where(account: current_user).find(params[:id])
      if question
        if  question.update(question_params)
          render json: QuestionSerializer.new(question).serializable_hash,
               status: :created
        else
          render json: ErrorSerializer.new(question).serializable_hash,
               status: :unprocessable_entity
        end
      else
        render json: {error: "question not found."}, status: :unprocessable_entity
      end
    end

    private

    def search_questions
      search = "%#{params[:search].to_s.downcase}%"
      questions = @questions.where("lower(title) like ? or lower(description) like ?", search, search).page(params[:page]).per(params[:per_page])
    end

    def assign_questions
      @questions = BxBlockCommunityforum::Question.all
    end

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: current_user&.id, answers: true, comments: true }
      options
    end

    def filter_question
      params.each do |key, value|
        case key
        when 'sub_category'
          @questions = @questions.where(sub_category_id: value)
        when 'tag'
          @questions = @questions.tagged_with(value, any: true)
        when 'is_popular'
          @questions = @questions.where(is_popular: value)
        when 'is_trending'
          @questions = @questions.where(is_trending: value)
        when 'is_recommended'
          @questions = @questions.where(sub_category: current_user&.sub_categories&.pluck(:id))
        end
      end
    end

    def set_account
      @account = AccountBlock::Account.find_by(id: params[:account_id])

      unless @account.present?
        render json: {error: "account not found."}, status: :unprocessable_entity        
      end
    end

    def question_params
      params.require(:question).permit(:title, :description, :sub_category_id, :status, :closed, :image, :tag_list)
    end
  end
end
