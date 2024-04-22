class CalendarController < ApplicationController
  before_action :authenticate

  def index
    @gigs = Gig.all
  end
end
