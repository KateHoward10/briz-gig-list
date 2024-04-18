class ResponsesController < ApplicationController
  before_action :authenticate

  def create
    if response_params[:status] != "Not going"
      @response = Response.new(response_params)
      @response.user = current_user
      if @response.save
        redirect_to gig_path(@response.gig_id)
      end
    end
  end

  def update
    @response = Response.find_by!(id: params[:id])
    if response_params[:status] == "Not going"
      @response.destroy
    else
      @response.update(response_params)
    end
    redirect_to gig_path(@response.gig_id)
  end

  private
    def response_params
      params.require(:response).permit(:gig_id, :status)
    end
end