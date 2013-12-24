class TestimonialsController < ApplicationController

	def create
		@website = Website.find(params[:website_id])
		@testimonial = @website.testimonials.create(params[:testimonial].permit(:comment))
		@testimonial.user_id = User.find(current_user.id)
		redirect_to website_path(@website.thread_id)
	end

end
