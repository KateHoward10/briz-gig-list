require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'

class GigsController < ApplicationController
  before_action :authenticate
  
  def index
    token = current_user.google_token
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = token.google_secret.to_authorization

    if token.expired?
      new_access_token = service.authorization.refresh!
      token.access_token = new_access_token['access_token']
      token.expires_at = 
        Time.now.to_i + new_access_token['expires_in'].to_i
      token.save
    end

    @gigs = service.list_events(ENV['GOOGLE_CALENDAR_ID'], time_min: Time.now.to_datetime.rfc3339).items
  end
end
