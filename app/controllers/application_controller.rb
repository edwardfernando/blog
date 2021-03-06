class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
	def is_logged_in
		if !user_signed_in?
			flash[:warning] = "Please sign in first."
			redirect_to login_path
		end
	end
end
