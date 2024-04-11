class HomeController < ApplicationController
  before_action :authenticate

  def index
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

    @responses = []
    @response_list = Response.order(updated_at: :desc).limit(10)
    @response_list.each do |response|
      if response.gig_id
      gig = @service.get_event(ENV['GOOGLE_CALENDAR_ID'], response.gig_id)
        @responses << {
          user: response.user,
          status: response.status,
          gig: gig,
          datetime: response.updated_at
        }
      end
    end
  end
end
