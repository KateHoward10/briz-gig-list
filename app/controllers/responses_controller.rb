class ResponsesController < ApplicationController
  before_action :authenticate

  def create
    @response = Response.new(response_params)
    @response.user = current_user
    if @response.save
      action = Action.new({
        user_id: current_user.id,
        gig_id: @response.gig_id,
        gig_name: params[:response][:gig_name],
        kind: "response",
        status: @response.status,
      })
      action.save
      redirect_to gig_path(@response.gig_id)
    end
  end

  def update
    @response = Response.find_by!(id: params[:id])
    if @response.update(response_params)
      action = Action.find_by(gig_id: @response.gig_id, user_id: @response.user_id)
      action.update({ status: @response.status })
      redirect_to gig_path(@response.gig_id)
    end
  end

  private
    def response_params
      params.require(:response).permit(:gig_id, :status)
    end
end