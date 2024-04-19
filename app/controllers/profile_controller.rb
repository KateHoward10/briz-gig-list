class ProfileController < ApplicationController
  def index
    @gigs = Gig.where(user_id: current_user.id).order(created_at: :desc).limit(3).to_a
    @responses = Response.where(user_id: current_user.id).order(created_at: :desc).limit(3).to_a
    @posts = Post.joins(:parent).where(user_id: current_user.id)
                 .or(Post.where(parent: { user_id: current_user.id }))
                 .order(created_at: :desc).limit(3).to_a
    @actions = (@gigs + @responses + @posts).sort! { |a, b| b.created_at <=> a.created_at }
    @actions_by_date = @actions.group_by { |a| a.created_at.to_date }
  end
end
