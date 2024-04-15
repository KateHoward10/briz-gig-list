class Gig < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :links, dependent: :destroy

  validates :summary, :start_date, presence: true
end
