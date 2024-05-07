class ReactionsController < ApplicationController
  before_action :authenticate

  def create
    @gig = Gig.find(params[:gig_id])
    @reaction = @gig.reactions.create(reaction_params)
    @reaction.user = current_user

    if @reaction.save
      redirect_to gig_path(@gig.id)
    end
  end

  private
    def reaction_params
      params.require(:reaction).permit(:emoji, :post_id)
    end
end