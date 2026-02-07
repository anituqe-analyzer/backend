module JwtAuthenticatable
  extend ActiveSupport::Concern

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    begin
      decoded = decode_token(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: "Unauthorized" }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { error: "Token has expired" }, status: :unauthorized
    end
  end

  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, secret_key)
  end

  def decode_token(token)
    decoded = JWT.decode(token, secret_key, true, { verify_expiration: true })[0]
    HashWithIndifferentAccess.new(decoded)
  end

  
  private

  def secret_key
    Rails.application.credentials.secret_key_base || Rails.application.secret_key_base
  end
end
