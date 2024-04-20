class FeedController < ApplicationController
  before_action :authenticate

  def index
    @gigs = Gig.order(created_at: :desc).to_a
    @responses = Response.order(created_at: :desc).to_a
    @posts = Post.order(created_at: :desc).to_a
    @links = Link.order(created_at: :desc).to_a
    @actions = (@gigs + @responses + @posts + @links).sort! { |a, b| b.created_at <=> a.created_at }
    @grouped_actions = @actions.group_by { |a| a.created_at.to_date }
    @actions_by_date = Kaminari.paginate_array(@grouped_actions, total_count: @grouped_actions.count).page(params[:page]).per(3)
  end
end
