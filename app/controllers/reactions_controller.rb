class ReactionsController < ApplicationController
  before_action :authenticate
  before_action :set_gig

  def create
    @reaction = Reaction.new(reaction_params)
    @reaction.user = current_user

    if @reaction.save
      redirect_to gig_path(@gig_id)
    end
  end

  def update
    @reaction = Reaction.find(params[:id])

    if @reaction.update(reaction_params)
      redirect_to gig_path(@gig_id)
    end
  end

  private
    def set_gig
      @gig_id = Post.find(params[:reaction][:post_id]).gig_id
    end

    def reaction_params
      params.require(:reaction).permit(:emoji, :post_id)
    end
end