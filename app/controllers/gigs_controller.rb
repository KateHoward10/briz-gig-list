class GigsController < ApplicationController
  before_action :authenticate
  before_action :set_gig, only: [:show, :edit, :update]
  
  def index
    @gigs = Gig.where("start_date >= ?", Date.today).order(:start_date)
    @gigs_by_month = @gigs.group_by {|a| a.start_date.strftime("%B %Y") }
  end

  def past
    @gigs = Gig.where("end_date < ?", Date.today).order(start_date: :desc)
    @gigs_by_month = @gigs.group_by {|a| a.start_date.strftime("%B %Y") }
  end

  def show
    @posts = Post.where(gig_id: params[:id])
    @post = Post.new

    @links = Link.where(gig_id: params[:id])
    @link = Link.new

    responses = Response.where(gig_id: params[:id])
    @going = responses.where(status: "Going").collect{ |x| x.user }
    @interested = responses.where(status: "Interested").collect{ |x| x.user }
    @response = responses.find_by(user_id: current_user.id).presence || Response.new

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
      params.require(:gig).permit(:summary, :start_date, :end_date, :location)
    end
end
