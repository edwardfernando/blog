class ProfilesController < ApplicationController
	def profile_init
		@user = User.find(params[:id])
	end

	def profile_compelete
		user = User.find(params[:id])
		user.name = params[:name]
		user.email = params[:email]

		user.save!

		sign_in_and_redirect user, :event => :authentication
	end
end
