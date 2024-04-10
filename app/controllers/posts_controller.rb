class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html { redirect_to gig_path(@post.gig_id), status: :created }
        format.json { render :show, status: :created }
      else
        format.html { redirect_to gig_path(@post.gig_id), status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def post_params
      params.require(:post).permit(:gig_id, :text)
    end
end