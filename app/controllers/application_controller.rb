class ApplicationController < ActionController::Base
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session[:user_id] = nil
  end
  
  helper_method :current_user
  
  def current_user
    @current_user ||= 
      if session[:user_id].present?
        User.find_by(id: session[:user_id])
      else
        nil
    end
  end
  
  def authenticate
    if current_user.nil?
      redirect_to(login_path)
    elsif current_user.tokens.last.expired?
      current_user.tokens.last.refresh!
    end
  end
end
