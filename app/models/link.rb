class Link < ApplicationRecord
  belongs_to :gig
  belongs_to :user

  validates :url, presence: true
  validate :url_valid

  def url_valid
    str = URI.parse(url) rescue false
    errors.add(:url, "must be a valid URL") unless str.kind_of?(URI::HTTP) || str.kind_of?(URI::HTTPS)
  end 
end
