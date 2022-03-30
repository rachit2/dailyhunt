module BxBlockCommunityforum
  class VotesController < ApplicationController
    # skip_before_action :validate_json_web_token, only: [:show, :index]

    def create
      if params[:vote].present? and params[:vote][:question_id].present?
        vote = current_user.votes.new(vote_params)

        if vote.save
          render json: VoteSerializer.new(vote).serializable_hash,
                 status: :created
        else
          render json: ErrorSerializer.new(vote).serializable_hash,
                 status: :unprocessable_entity
        end
      else
        render json: {error: "Question not found"}, status: :unprocessable_entity
      end
    end

    private

    def serialization_options
      options = {}
      options[:params] = { current_user_id: current_user&.id, answers: true, comments: true}
      options
    end

    def vote_params
      params.require(:vote).permit(:question_id)
    end
  end
end
