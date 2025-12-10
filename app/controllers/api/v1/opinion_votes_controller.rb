module Api
  module V1
    class OpinionVotesController < ApplicationController
      include JwtAuthenticatable

      skip_before_action :verify_authenticity_token
      before_action :authorize_request
      before_action :set_opinion

      # POST /api/v1/opinions/:opinion_id/votes
      def create
        # Check if user already voted
        existing_vote = @opinion.opinion_votes.find_by(user: @current_user)

        if existing_vote
          # Update existing vote
          if existing_vote.update(vote_type: vote_params[:vote_type])
            @opinion.update_score!
            render json: vote_json(existing_vote), status: :ok
          else
            render json: { errors: existing_vote.errors.full_messages }, status: :unprocessable_entity
          end
        else
          # Create new vote
          @vote = @opinion.opinion_votes.build(vote_params)
          @vote.user = @current_user

          if @vote.save
            @opinion.update_score!
            render json: vote_json(@vote), status: :created
          else
            render json: { errors: @vote.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

      # DELETE /api/v1/opinions/:opinion_id/votes
      def destroy
        @vote = @opinion.opinion_votes.find_by(user: @current_user)

        if @vote
          @vote.destroy
          @opinion.update_score!
          head :no_content
        else
          render json: { error: "Vote not found" }, status: :not_found
        end
      end

      private

      def set_opinion
        @opinion = Opinion.find(params[:opinion_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Opinion not found" }, status: :not_found
      end

      def vote_params
        params.require(:vote).permit(:vote_type)
      end

      def vote_json(vote)
        {
          id: vote.id,
          vote_type: vote.vote_type,
          opinion_id: vote.opinion_id,
          user_id: vote.user_id,
          created_at: vote.created_at
        }
      end
    end
  end
end
