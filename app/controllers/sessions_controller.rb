class SessionsController < ApplicationController
  def destroy
    # Use the Clerk SDK to revoke the session (optional but ensures server-side logout)
    clerk_sid = clerk.session["sid"] rescue nil
    Clerk::SDK.new.sessions.revoke(session_id: clerk_sid) if clerk_sid

    # Clear Rails session and Clerk cookies
    reset_session
    cookies.delete("__session")      # Clerk cookie (production)
    cookies.delete("__clerk_db_jwt") # Clerk dev JWT (if using dev environment)

    redirect_to events_path, notice: "Logged out successfully"
  end
end
