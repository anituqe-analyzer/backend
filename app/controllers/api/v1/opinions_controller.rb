module Api
  module V1
    class OpinionsController < ApplicationController
      include JwtAuthenticatable

      skip_before_action :verify_authenticity_token
      before_action :authorize_request
      before_action :set_auction, only: [ :index, :create ]
      before_action :set_opinion, only: [ :show, :update, :destroy ]

      # GET /api/v1/auctions/:auction_id/opinions
      def index
        @opinions = @auction.opinions.includes(:user, :opinion_votes).order(created_at: :desc)

        render json: {
          opinions: @opinions.map { |opinion| opinion_json(opinion) }
        }, status: :ok
      end

      # GET /api/v1/opinions/:id
      def show
        render json: opinion_json(@opinion), status: :ok
      end

      # POST /api/v1/auctions/:auction_id/opinions
      def create
        @opinion = @auction.opinions.build(opinion_params)
        @opinion.user = @current_user
        @opinion.author_type = @current_user.expert? ? "expert" : "user"

        if @opinion.save
          render json: opinion_json(@opinion), status: :created
        else
          render json: { errors: @opinion.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/opinions/:id
      def update
        unless @opinion.user_id == @current_user.id
          render json: { error: "Unauthorized" }, status: :forbidden
          return
        end

        if @opinion.update(opinion_params)
          render json: opinion_json(@opinion), status: :ok
        else
          render json: { errors: @opinion.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/opinions/:id
      def destroy
        unless @opinion.user_id == @current_user.id || @current_user.admin?
          render json: { error: "Unauthorized" }, status: :forbidden
          return
        end

        @opinion.destroy
        head :no_content
      end

      private

      def set_auction
        @auction = Auction.find(params[:auction_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Auction not found" }, status: :not_found
      end

      def set_opinion
        @opinion = Opinion.includes(:user, :auction, :opinion_votes).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Opinion not found" }, status: :not_found
      end

      def opinion_params
        params.require(:opinion).permit(:content, :verdict)
      end

      def opinion_json(opinion)
        {
          id: opinion.id,
          content: opinion.content,
          verdict: opinion.verdict,
          author_type: opinion.author_type,
          score: opinion.score,
          user: {
            id: opinion.user.id,
            username: opinion.user.username,
            role: opinion.user.role
          },
          auction: {
            id: opinion.auction.id,
            title: opinion.auction.title
          },
          votes_count: opinion.opinion_votes.count,
          created_at: opinion.created_at,
          updated_at: opinion.updated_at
        }
      end
    end
  end
end
