class LinksController < ApplicationController
  before_action :authenticate
  before_action :set_gig

  def new
  end

  def create
    @link = @gig.links.create(link_params)
    @link.user = current_user

    if @link.valid?
      @link.save

      action = Action.new({ user_id: current_user.id, gig_id: @gig.id, kind: "link" })
      action.save

      redirect_to gig_path(@gig.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_gig
      @gig = Gig.find(params[:gig_id])
    end

    def link_params
      params.require(:link).permit(:url, :text)
    end
end