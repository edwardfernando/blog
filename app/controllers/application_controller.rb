class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
	def is_logged_in
		if !user_signed_in?
			flash.now[:notice] = "Please sign in first."
			redirect_to new_user_session_path
		end
	end
end
