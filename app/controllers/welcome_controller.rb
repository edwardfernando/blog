class WelcomeController < ApplicationController
  
  def index
  	@websites_list = Website.where("content is not null").order(updated_at: :desc)
    @testimonials_list = Testimonial.all.order(updated_at: :desc)
  end

  def login
  end

  def destroy
  	reset_session
  	flash[:success] = "Log out succeffully"
  	redirect_to root_path
  end
end
