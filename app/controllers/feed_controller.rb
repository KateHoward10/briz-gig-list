class FeedController < ApplicationController
  before_action :authenticate

  def index
    @actions = Action.order(created_at: :desc).limit(20)
    @actions_by_date = @actions.group_by {|a| a.created_at.to_date }
  end
end
