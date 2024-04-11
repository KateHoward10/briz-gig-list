class HomeController < ApplicationController
  def index
    if current_user.present?
      @actions = Action.order(updated_at: :desc).limit(20)
    end
  end
end
