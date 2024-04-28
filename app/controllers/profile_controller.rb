class ProfileController < ApplicationController
  before_action :authenticate

  def index
    @responses = Response.joins(:gig).where(user_id: current_user.id).where(gig: Gig.where("start_date >= ?", Date.today))
    @going = @responses.where(status: "Going").order("gigs.start_date").page(params[:page]).per(10)
    @interested = @responses.where(status: "Interested").order("gigs.start_date").page(params[:page]).per(10)
  end
end
