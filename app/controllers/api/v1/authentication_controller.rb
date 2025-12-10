module Api
  module V1
    class AuthenticationController < ApplicationController
      include JwtAuthenticatable

      skip_before_action :verify_authenticity_token

      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = encode_token(user_id: user.id)
          render json: {
            token: token,
            user: {
              id: user.id,
              username: user.username,
              email: user.email,
              role: user.role
            }
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end
    end
  end
end
