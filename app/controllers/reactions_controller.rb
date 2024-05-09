class ReactionsController < ApplicationController
  before_action :authenticate
  before_action :set_gig, only: [:create, :update]
  before_action :set_reaction, only: [:update, :destroy]

  def create
    @reaction = Reaction.new(reaction_params)
    @reaction.user = current_user

    if @reaction.save
      redirect_to gig_path(@gig_id)
    end
  end

  def update
    if @reaction.update(reaction_params)
      redirect_to gig_path(@gig_id)
    end
  end

  def destroy
    if @reaction.destroy
      redirect_to gig_path(@reaction.post.gig_id)
    end
  end

  private
    def set_gig
      @gig_id = Post.find(params[:reaction][:post_id]).gig_id
    end

    def set_reaction
      @reaction = Reaction.find(params[:id])
      return unless @reaction.user_id == current_user.id
    end

    def reaction_params
      params.require(:reaction).permit(:emoji, :post_id)
    end
end