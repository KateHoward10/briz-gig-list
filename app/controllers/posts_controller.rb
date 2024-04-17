class PostsController < ApplicationController
  before_action :authenticate

  def create
    @gig = Gig.find(params[:gig_id])
    @post = @gig.posts.create(post_params)
    @post.user = current_user

    if @post.save
      action = Action.new({
        user_id: current_user.id,
        gig_id: @post.gig_id,
        kind: "post",
        text: @post.text
      })
      action.save
      redirect_to gig_path(@post.gig_id)
    end
  end

  private
    def post_params
      params.require(:post).permit(:text, :parent_id)
    end
end