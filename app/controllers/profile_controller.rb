class ProfileController < ApplicationController
  def index
    @actions = Action.where(user_id: current_user.id).order(updated_at: :desc).limit(20)
  end
end
