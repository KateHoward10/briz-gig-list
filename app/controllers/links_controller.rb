require 'nokogiri'
require 'open-uri'

class LinksController < ApplicationController
  before_action :authenticate

  def create
    @link = Link.new(link_params)
    @link.user = current_user

    if @link.url.present?
      URI.open(@link.url) do |f|
        doc = Nokogiri::HTML(f)
        title = doc.at_css('title')
        if title.present?
          @link.text = title.content
        end
      end
    end

    if @link.save
      action = Action.new({
        user_id: current_user.id,
        gig_id: @link.gig_id,
        kind: "link",
        text: @link.url
      })
      action.save
      redirect_to gig_path(@link.gig_id)
    end
  end

  private
    def link_params
      params.require(:link).permit(:gig_id, :url)
    end
end