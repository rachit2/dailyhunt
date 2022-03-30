module BxBlockCommunityforum
  class AnswersController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:show, :index]

    def show
      answer = BxBlockCommunityforum::Answer.find_by(id: params[:id])
      render json: AnswerSerializer.new(answer, serialization_options).serializable_hash, status: :ok
    end

    def index
      answers = BxBlockCommunityforum::Answer.all.page(params[:page]).per(params[:per_page])
      render json: AnswerSerializer.new(answers).serializable_hash, status: :ok
    end

    def create
      answer = current_user.answers.new(answer_params)
      if params[:answer].present? and params[:answer][:question_id].present? 
        if answer.save
          render json: AnswerSerializer.new(answer).serializable_hash,
                 status: :created
        else
          render json: ErrorSerializer.new(answer).serializable_hash,
                 status: :unprocessable_entity
        end
      else
        render json: {error: "Question not found"}, status: :unprocessable_entity
      end
    end

    private
    
    def serialization_options
      options = {}
      options[:params] = { current_user_id: current_user&.id}
      options
    end

    def answer_params
      params.require(:answer).permit(:title, :description, :question_id)
    end
  end
end
