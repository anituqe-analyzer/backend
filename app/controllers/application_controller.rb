class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Active Admin authentication
  def authenticate_admin!
    authenticate_or_request_with_http_basic("Active Admin") do |username, password|
      user = User.find_by(username: username)
      if user&.authenticate(password) && user.admin?
        @current_admin_user = user
        true
      else
        false
      end
    end
  end

  def current_admin_user
    @current_admin_user
  end
end
