class PostsController < ApplicationController
  before_action :authenticate

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      action = Action.new({
        user_id: current_user.id,
        gig_id: @post.gig_id,
        gig_name: params[:post][:gig_name],
        kind: "post",
        text: @post.text
      })
      action.save
      redirect_to gig_path(@post.gig_id)
    end
  end

  private
    def post_params
      params.require(:post).permit(:gig_id, :text)
    end
end