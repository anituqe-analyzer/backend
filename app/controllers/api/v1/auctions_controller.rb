module Api
  module V1
    class AuctionsController < ApplicationController
      include JwtAuthenticatable

      skip_before_action :verify_authenticity_token
      before_action :authorize_request, except: [ :index, :show ]
      before_action :set_auction, only: [ :show, :update, :destroy ]

      def index
        @auctions = Auction.includes(:category, :submitted_by_user, images_attachments: :blob)
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(params[:per_page] || 20)

        render json: {
          auctions: @auctions.map { |auction| auction_json(auction) },
          meta: pagination_meta(@auctions)
        }, status: :ok
      end

      def show
        render json: auction_json(@auction, include_opinions: true), status: :ok
      end

      def create
        @auction = @current_user.auctions.build(auction_params)

        if @auction.save
          render json: auction_json(@auction), status: :created
        else
          render json: { errors: @auction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        unless @auction.submitted_by_user_id == @current_user.id || @current_user.admin?
          render json: { error: "Unauthorized" }, status: :forbidden
          return
        end

        if @auction.update(auction_params)
          render json: auction_json(@auction), status: :ok
        else
          render json: { errors: @auction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        unless @auction.submitted_by_user_id == @current_user.id || @current_user.admin?
          render json: { error: "Unauthorized" }, status: :forbidden
          return
        end

        @auction.destroy
        head :no_content
      end

      private

      def set_auction
        @auction = Auction.includes(:category, :submitted_by_user, :opinions, images_attachments: :blob).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Auction not found" }, status: :not_found
      end

      def auction_params
        params.require(:auction).permit(:title, :description_text, :price, :currency, :external_link, :category_id, images: [])
      end

      def auction_json(auction, include_opinions: false)
        json = {
          id: auction.id,
          title: auction.title,
          description: auction.description_text,
          price: auction.price,
          currency: auction.currency,
          external_link: auction.external_link,
          verification_status: auction.verification_status,
          ai_score_authenticity: auction.ai_score_authenticity,
          ai_uncertainty_message: auction.ai_uncertainty_message,
          category: {
            id: auction.category.id,
            name: auction.category.name
          },
          submitted_by: {
            id: auction.submitted_by_user.id,
            username: auction.submitted_by_user.username
          },
          images: auction.images.map { |img| rails_blob_url(img) },
          created_at: auction.created_at,
          updated_at: auction.updated_at
        }

        if include_opinions
          json[:opinions] = auction.opinions.includes(:user).map do |opinion|
            {
              id: opinion.id,
              content: opinion.content,
              verdict: opinion.verdict,
              author_type: opinion.author_type,
              score: opinion.score,
              user: {
                id: opinion.user.id,
                username: opinion.user.username
              },
              created_at: opinion.created_at
            }
          end
        end

        json
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
