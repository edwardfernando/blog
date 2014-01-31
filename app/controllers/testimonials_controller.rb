class TestimonialsController < ApplicationController

	before_action :is_logged_in

	def create
		website = Website.find(params[:website_id])
		testimonial = website.testimonials.create(comment:params[:rich_textarea_content], user:current_user, random_id:SecureRandom.urlsafe_base64(5))	
		redirect_to website_path(website.thread_id)
	end

end
