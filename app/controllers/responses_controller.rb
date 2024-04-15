class ResponsesController < ApplicationController
  before_action :authenticate

  def create
    if response_params[:status] != "Not going"
      @response = Response.new(response_params)
      @response.user = current_user
      if @response.save
        @action = Action.new({
          user_id: current_user.id,
          gig_id: @response.gig_id,
          kind: "response",
          status: @response.status,
        })
        @action.save
        redirect_to gig_path(@response.gig_id)
      end
    end
  end

  def update
    @response = Response.find_by!(id: params[:id])
    @action = Action.find_by(gig_id: @response.gig_id, user_id: @response.user_id, kind: "response")
    if response_params[:status] == "Not going"
      @response.destroy
      @action.destroy
    elsif @response.update(response_params)
      @action.update({ status: @response.status })
    end
    redirect_to gig_path(@response.gig_id)
  end

  private
    def response_params
      params.require(:response).permit(:gig_id, :status)
    end
end