class ProfileController < ApplicationController
  def index
    get_actions(current_user.id)
  end

  def show
    @user = User.find(params[:id])
    get_actions(params[:id])
  end

  private
    def get_actions(id)
      @gigs = Gig.where(user_id: id).order(created_at: :desc).to_a
      @responses = Response.where(user_id: id).order(created_at: :desc).to_a
      @posts = Post.joins(:parent).where(user_id: id)
                  .or(Post.where(parent: { user_id: id }))
                  .order(created_at: :desc).to_a
      @actions = (@gigs + @responses + @posts).sort! { |a, b| b.created_at <=> a.created_at }
      @grouped_actions = @actions.group_by { |a| a.created_at.to_date }
      @actions_by_date = Kaminari.paginate_array(@grouped_actions, total_count: @grouped_actions.count).page(params[:page]).per(3)
    end
end
