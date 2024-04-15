class Post < ApplicationRecord
  belongs_to :gig
  belongs_to :user

  validates :text, presence: true
end
