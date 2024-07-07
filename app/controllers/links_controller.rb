class LinksController < ApplicationController
  before_action :authenticate
  before_action :set_gig

  def new
  end

  def create
    @link = @gig.links.create(link_params)
    @link.user = current_user

    if @link.save
      unless link_params[:image].blank?
        @gig.image = link_params[:image]
        @gig.save
      end
      redirect_to gig_path(@gig.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @link = Link.find(params[:id])
    if @link.destroy
      redirect_to gig_path(@link.gig_id)
    end
  end

  private
    def set_gig
      @gig = Gig.find(params[:gig_id])
    end

    def link_params
      params.require(:link).permit(:url, :text, :image)
    end
end