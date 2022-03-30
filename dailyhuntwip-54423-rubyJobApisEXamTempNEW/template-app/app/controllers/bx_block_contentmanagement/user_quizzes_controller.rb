module BxBlockContentmanagement
  class UserQuizzesController < ApplicationController

    def create
      user_quizzes = current_user.user_quizzes.where(quiz_id: params[:quiz_id]) 
      attempt_count = user_quizzes.last&.attempt_count || 0
      user_quizzes.destroy_all
      user_quiz = current_user.user_quizzes.new(quiz_id: params[:quiz_id], attempt_count: attempt_count + 1)
      if user_quiz.save
        render json: UserQuizSerializer.new(user_quiz).serializable_hash, status: :ok
      else
        render json: {errors: user_quiz.errors}, status: :unprocessable_entity
      end
    end

    def index
      render json: UserQuizSerializer.new(current_user.user_quizzes)
    end

    def user_option
      user_quiz = current_user.user_quizzes.find_by(quiz_id: params[:quiz_id])
      if user_quiz.present?
        user_option = user_quiz.user_options.new(option_params)
        user_option.is_true = user_option.option.is_right
        if user_option.save
          render json: UserOptionSerializer.new(user_option).serializable_hash, status: :ok
        else
          render json: {errors: user_option.errors}, status: :unprocessable_entity
        end
      else
        render json: {error: 'User Quiz with this quiz id does not found'}, status: :unprocessable_entity
      end
    end

    def option
      user_quiz = UserQuiz.find(params[:id])
      user_option = user_quiz.user_options.find_by(test_question_id: params[:test_question_id])
      if user_option.present?
        render json: UserOptionSerializer.new(user_option).serializable_hash, status: :ok
      else
        render json: {error: "question not found or you not answer this question yet."}
      end
    end

    def my_score
      user_quiz = current_user.user_quizzes.find_by(quiz_id: params[:quiz_id])
      render json: UserQuizSerializer.new(user_quiz).serializable_hash, status: :ok
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

    private 

    def option_params
      params.require(:data).permit \
        :test_question_id,
        :option_id
    end

  end
end
