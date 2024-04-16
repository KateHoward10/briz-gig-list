class VenuesController < ApplicationController
  before_action :authenticate

  def index
    @venues = Gig.distinct.pluck(:location)
  end

  def show
    @venue = params[:id]
    @gigs = Gig.where(location: params[:id]).where("start_date >= ?", Date.today).order(:start_date)
    @gigs_by_month = @gigs.group_by {|a| a.start_date.strftime("%B %Y") }
  end
end
