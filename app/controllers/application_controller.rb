class ApplicationController < ActionController::Base
  include Clerk::Authenticatable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  def current_user
    clerk.user&.id
  end

  private

  def require_clerk_user
    return if current_user.present?

    redirect_to "#{ENV['CLERK_SIGN_IN_URL']}", allow_other_host: true
  end
end
