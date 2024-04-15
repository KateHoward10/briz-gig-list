class Link < ApplicationRecord
  belongs_to :gig
  belongs_to :user

  validates :url, presence: true
end
