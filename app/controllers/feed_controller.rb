class FeedController < ApplicationController
  before_action :authenticate

  def index
    @gigs = Gig.order(created_at: :desc).limit(5).to_a
    @responses = Response.order(created_at: :desc).limit(5).to_a
    @posts = Post.order(created_at: :desc).limit(5).to_a
    @actions = (@gigs + @responses + @posts).sort! { |a, b| b.created_at <=> a.created_at }
    @actions_by_date = @actions.group_by {|a| a.created_at.to_date }
  end
end
