module Api
  module V1
    class UsersController < ApplicationController
      include JwtAuthenticatable

      skip_before_action :verify_authenticity_token
      before_action :authorize_request
      before_action :set_user, only: [ :show, :update ]

      def show
        render json: {
          id: @user.id,
          username: @user.username,
          email: @user.email,
          role: @user.role
        }, status: :ok
      end

      def update
        if @user.update(user_params)
          render json: {
            id: @user.id,
            username: @user.username,
            email: @user.email,
            role: @user.role
          }, status: :ok
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = @current_user
      end

      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
    end
  end
end
