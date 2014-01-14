class ProfilesController < ApplicationController
	
	def index
		@user = current_user
	end

	def profile_init
		@user = User.find(params[:id])
	end

	def profile_complete
		@user = User.find(params[:id])

		@user.name = params[:name]
		@user.email = params[:email]

		if @user.save
			sign_in(@user)
			redirect_to profiles_path
		else
			render 'profile_init'
		end
	end
end
