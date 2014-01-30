class ProfilesController < ApplicationController
	
	before_action :is_logged_in

	def index
		@user = current_user
	end

	def profile_init
		@user = User.where(:random_id => params[:id]).first

		if @user.profile_is_complete
			redirect_to profiles_path
		end
	end

	def profile_complete
		@user = User.where(:random_id => params[:id]).first

		if @user.profile_is_complete
			redirect_to profiles_path
		end

		@user.name = params[:name]
		@user.email = params[:email]
		@user.kaskus_id = params[:kaskus_id]

		@user.profile_is_complete = 1

		if @user.save
			sign_in(@user)
			redirect_to profiles_path
		else
			render 'profile_init'
		end
	end

	def profile_update
		@user = User.where(:id => current_user.id).first
		@user.name = params[:user][:name]
		@user.email = params[:user][:email]

		if @user.save
			flash[:success] = "Your profile succeffully updated"
			redirect_to profiles_path
		else
			render 'index'
		end	
	end

end
