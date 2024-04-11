class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to gig_path(@post.gig_id)
    end
  end

  private
    def post_params
      params.require(:post).permit(:gig_id, :text)
    end
end