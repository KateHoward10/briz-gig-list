class ProfileController < ApplicationController
  def index
    @actions = Action.where(user_id: current_user.id).order(updated_at: :desc).limit(20)
    @actions_by_date = @actions.group_by {|a| a.updated_at.to_date }
  end
end
