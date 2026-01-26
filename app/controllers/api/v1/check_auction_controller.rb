require_relative "../../../services/url_validation_service"

module Api
  module V1
    class CheckAuctionController < ApplicationController
      skip_before_action :verify_authenticity_token

      def validate
        auction_url = params[:auction_url]

        if auction_url.blank?
          render json: { error: "auction_url parameter is required" }, status: :bad_request
          return
        end

        validation_service = UrlValidationService.new(auction_url)
        result = validation_service.call

        if result[:error]
          render json: result, status: :unprocessable_entity
        else
          render json: { success: true, validation_result: result }, status: :ok
        end
      end
    end
  end
end
