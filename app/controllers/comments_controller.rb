class CommentsController < ApplicationController

	def create
		@post = Post.find(params[:post_id])
		@comments = @post.comments.create(params[:comment].permit(:commenter, :body))
		redirect_to_path(@post)
	end

end
