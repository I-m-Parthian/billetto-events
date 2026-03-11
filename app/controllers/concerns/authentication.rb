module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_clerk_user
    helper_method :current_user
  end

  def current_user
    session[:clerk_user_id]
  end

  def authenticate_user!
    return if current_user.present?

    redirect_to "#{ENV['CLERK_FRONTEND_URL']}/sign-in"
  end

  private

  def set_clerk_user
    return if session[:clerk_user_id].present?

    token = params[:__clerk_db_jwt]
    return unless token

    clerk = Clerk::SDK.new(secret_key: ENV.fetch("CLERK_SECRET_KEY"))

    debugger
    clerk.session
    
    session_data = clerk.sessions.get(token)

    session[:clerk_user_id] = session_data.user_id

    Rails.logger.debug "Clerk user authenticated: #{session[:clerk_user_id]}"
  rescue => e
    Rails.logger.error "Clerk verification failed: #{e.message}"
  end
end
