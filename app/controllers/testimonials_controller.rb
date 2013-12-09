class TestimonialsController < ApplicationController

	def create
		@website = Website.find(params[:website_id])
		@testimonial = @website.testimonials.create(params[:testimonial].permit(:comment))
		redirect_to website_path(@website)
	end

end
