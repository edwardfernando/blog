class TestimonialsController < ApplicationController

	before_action :is_logged_in

	def create
		website = Website.find(params[:website_id])
		testimonial = website.testimonials.create(comment:params[:rich_textarea_content], user:current_user, random_id:SecureRandom.urlsafe_base64(5),
			rating:params[:rating], 
			accurate_description:params[:accurate_description], 
			communication:params[:communication], 
			shipping_speed:params[:shipping_speed], shipping_cost:params[:shipping_cost])	

		redirect_to website_path(website.thread_id)
	end

end
