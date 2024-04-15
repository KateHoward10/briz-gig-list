class Response < ApplicationRecord
  belongs_to :gig
  belongs_to :user

  validates :status, presence: true
end
