require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'

class GigsController < ApplicationController
  before_action :authenticate
  before_action :set_service, except: [:new]
  
  def index
    @gigs = @service.list_events(
      ENV['GOOGLE_CALENDAR_ID'],
      single_events: true,
      time_min: Time.now.to_datetime.rfc3339,
      order_by: "startTime"
    ).items

    rescue => e
      flash[:error] = 'You are not authorised to view this calendar'
  end

  def past
    @gigs = @service.list_events(
      ENV['GOOGLE_CALENDAR_ID'],
      single_events: true,
      time_max: Time.now.to_datetime.rfc3339,
      order_by: "startTime"
    ).items.reverse
  end

  def show
    @gig = @service.get_event(ENV['GOOGLE_CALENDAR_ID'], params[:id])
    @posts = Post.where(gig_id: params[:id])
    @post = Post.new

    responses = Response.where(gig_id: params[:id])
    @going = responses.where(status: "Going").collect{ |x| x.user }
    @interested = responses.where(status: "Interested").collect{ |x| x.user }
    @response = responses.where(user_id: current_user.id).last || Response.new

    start_date = @gig.start.date || @gig.start.date_time
    end_date = @gig.end.date || @gig.end.date_time
    @clashes = []
    @clash_list = @service.list_events(
      ENV['GOOGLE_CALENDAR_ID'],
      time_min: start_date.to_datetime.rfc3339,
      time_max: end_date.to_datetime.rfc3339
    )
    @clash_list.items.each do |clash|
      @clashes << clash unless clash.id == @gig.id
    end
  end

  def new
  end

  def create
    gig = Google::Apis::CalendarV3::Event.new(
      summary: params[:description],
      start: Google::Apis::CalendarV3::EventDateTime.new(date: params[:start_date]),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: params[:end_date]),
      location: params[:location]
    )

    @service.insert_event(ENV['GOOGLE_CALENDAR_ID'], gig)
    flash[:notice] = 'Gig was successfully added.'
    redirect_to gigs_path

    rescue => e
      flash[:error] = 'You are not authorised to create gigs'
      redirect_to root_url
  end

  private
    def set_service
      token = current_user.google_token
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.authorization = token.google_secret.to_authorization
  
      if token.expired?
        new_access_token = @service.authorization.refresh!
        token.access_token = new_access_token['access_token']
        token.expires_at = 
          Time.now.to_i + new_access_token['expires_in'].to_i
        token.save
      end
    end
end
