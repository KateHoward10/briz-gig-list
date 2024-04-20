class VenuesController < ApplicationController
  before_action :authenticate

  def index
    @venues = Gig.distinct.pluck(:location).sort
  end

  def show
    @venue = params[:id]
    @gigs = Gig.where(location: params[:id]).where("start_date >= ?", Date.today).order(:start_date)
    @grouped_gigs = @gigs.group_by { |a| a.start_date.strftime("%B %Y") }
    @gigs_by_month = Kaminari.paginate_array(@grouped_gigs, total_count: @grouped_gigs.count).page(params[:page]).per(3)
  end
end
