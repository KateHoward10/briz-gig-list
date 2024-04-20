class GigsController < ApplicationController
  before_action :authenticate
  before_action :set_gig, only: [:show, :edit, :update]
  
  def index
    @gigs = Gig.where("start_date >= ?", Date.today).order(:start_date)
    @gigs_by_month = @gigs.group_by { |a| a.start_date.strftime("%B %Y") }
  end

  def past
    @gigs = Gig.where("end_date < ?", Date.today).order(start_date: :desc)
    @gigs_by_month = @gigs.group_by { |a| a.start_date.strftime("%B %Y") }
  end

  def show
    @posts_by_date = @gig.posts.group_by { |a| a.created_at.to_date }
    @post = Post.new
    @parent_post = params[:parent_id].present? ? Post.find(params[:parent_id]) : nil

    @link = Link.new

    @going_list = @gig.responses.where(status: "Going").where.not(user_id: current_user.id).collect{ |x| x.user }
    @interested_list = @gig.responses.where(status: "Interested").where.not(user_id: current_user.id).collect{ |x| x.user }
    @response = @gig.responses.find_by(user_id: current_user.id).presence || Response.new
    @going = @response.status == "Going" ? @going_list.unshift(current_user) : @going_list
    @interested = @response.status == "Interested" ? @interested_list.unshift(current_user) : @interested_list

    @clashes = Gig.where.not(id: @gig.id)
                  .where("start_date <= ?", @gig.end_date)
                  .where("end_date >= ?", @gig.start_date)
  end

  def new
    @gig = Gig.new()
  end

  def create
    @gig = Gig.new(gig_params)
    @gig.user = current_user

    if @gig.save
      redirect_to gig_path(@gig.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if current_user.id != @gig.user_id
      redirect_to gigs_path
      flash[:alert] = "You are not authorised to edit this gig"
    end
  end

  def update
    if @gig.update(gig_params)
      redirect_to gig_path(@gig.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_gig
      @gig = Gig.find(params[:id])
    end

    def gig_params
      params[:gig][:end_date] = params[:gig][:start_date] if params[:gig][:end_date].blank?
      params.require(:gig).permit(:summary, :start_date, :end_date, :location, links_attributes: [:url, :text, :user_id])
    end
end
