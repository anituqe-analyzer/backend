module Api
  module V1
    class CategoriesController < ApplicationController
      skip_before_action :verify_authenticity_token

      # GET /api/v1/categories
      def index
        @categories = Category.includes(:parent, :children).order(:name)

        render json: {
          categories: @categories.map { |category| category_json(category) }
        }, status: :ok
      end

      # GET /api/v1/categories/:id
      def show
        @category = Category.includes(:parent, :children, :auctions).find(params[:id])

        render json: category_json(@category, include_auctions: true), status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Category not found" }, status: :not_found
      end

      private

      def category_json(category, include_auctions: false)
        json = {
          id: category.id,
          name: category.name,
          description: category.description,
          parent: category.parent ? { id: category.parent.id, name: category.parent.name } : nil,
          children: category.children.map { |child| { id: child.id, name: child.name } },
          created_at: category.created_at
        }

        if include_auctions
          json[:auctions_count] = category.auctions.count
          json[:recent_auctions] = category.auctions.order(created_at: :desc).limit(5).map do |auction|
            {
              id: auction.id,
              title: auction.title,
              verification_status: auction.verification_status,
              created_at: auction.created_at
            }
          end
        end

        json
      end
    end
  end
end
