class TestimonialsController < ApplicationController

	def create
		website = Website.find(params[:website_id])
		testimonial = website.testimonials.create(comment:params[:rich_textarea_content], user:current_user)	
		redirect_to website_path(website.thread_id)
	end

end
