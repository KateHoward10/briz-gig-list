class FeedController < ApplicationController
  before_action :authenticate

  def index
    @actions = Action.order(updated_at: :desc).limit(20)
  end
end
