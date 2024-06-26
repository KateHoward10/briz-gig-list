class SessionsController < ApplicationController
  
  def google_login
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)

    log_in(user)
    
    token = user.tokens.find_or_initialize_by(provider: 'google')
    token.access_token = auth.credentials.token
    token.expires_at = auth.credentials.expires_at
    refresh_token = auth.credentials.refresh_token
    token.refresh_token = refresh_token if refresh_token.present?
    token.save

    redirect_to root_path
  end

  def logout
    log_out
    redirect_to login_path
  end
end