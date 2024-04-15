require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'

class GigsController < ApplicationController
  before_action :authenticate
  before_action :set_service, except: [:new]
  before_action :set_gig, only: [:create, :update]
  
  def index
    @gigs = @service.list_events(
      ENV['GOOGLE_CALENDAR_ID'],
      single_events: true,
      time_min: DateTime.now.midnight.to_datetime.rfc3339,
      order_by: "startTime"
    ).items
  end

  def past
    @gigs = @service.list_events(
      ENV['GOOGLE_CALENDAR_ID'],
      single_events: true,
      time_max: DateTime.now.midnight.to_datetime.rfc3339,
      order_by: "startTime"
    ).items.reverse
  end

  def show
    @gig = @service.get_event(ENV['GOOGLE_CALENDAR_ID'], params[:id])

    @posts = Post.where(gig_id: params[:id])
    @post = Post.new

    @links = Link.where(gig_id: params[:id])
    @link = Link.new

    responses = Response.where(gig_id: params[:id])
    @going = responses.where(status: "Going").collect{ |x| x.user }
    @interested = responses.where(status: "Interested").collect{ |x| x.user }
    @response = responses.find_by(user_id: current_user.id).presence || Response.new

    start_date = @gig.start.date.presence || @gig.start.date_time
    end_date = @gig.end.date.presence || @gig.end.date_time
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
    @gig = OpenStruct.new({
      summary: nil,
      start: nil,
      end: nil,
      location: nil
    })
  end

  def create
    result = @service.insert_event(ENV['GOOGLE_CALENDAR_ID'], @gig)

    if result.id.present?
      action = Action.new({
        user_id: current_user.id,
        gig_id: result.id,
        gig_name: @gig.summary,
        kind: "gig"
      })
      action.save
    end

    redirect_to gigs_path
  end

  def edit
    @gig = @service.get_event(ENV['GOOGLE_CALENDAR_ID'], params[:id])
    if current_user.email != @gig.creator.email
      redirect_to gigs_path
      flash[:alert] = "You are not authorised to edit this gig"
    end
  end

  def update
    result = @service.update_event(ENV['GOOGLE_CALENDAR_ID'], params[:id], @gig)

    if result.id.present?
      actions = Action.where(gig_id: result.id)
      if actions.any? && result.summary.present?
        actions.each do |action|
          action.update({ gig_name: result.summary })
        end
      end
      redirect_to gigs_path
    end
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

    def set_gig
      @gig = Google::Apis::CalendarV3::Event.new(
        summary: params[:description],
        start: Google::Apis::CalendarV3::EventDateTime.new(date: params[:start_date]),
        end: Google::Apis::CalendarV3::EventDateTime.new(date: params[:end_date].presence || params[:start_date]),
        location: params[:location]
      )
    end
end
