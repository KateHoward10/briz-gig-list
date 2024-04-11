class ResponsesController < ApplicationController
  def create
    @response = Response.new(response_params)
    @response.user = current_user
    if @response.save
      redirect_to gig_path(@response.gig_id)
    end
  end

  def update
    @response = Response.find_by!(id: params[:id])
    if @response.update(response_params)
      redirect_to gig_path(@response.gig_id)
    end
  end

  private
    def response_params
      params.require(:response).permit(:gig_id, :status)
    end
end