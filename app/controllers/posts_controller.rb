class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save
  end

  private
    def post_params
      params.require(:post).permit(:gig_id, :text)
    end
end