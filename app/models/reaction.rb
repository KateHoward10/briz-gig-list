class Reaction < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :gig, through: :post
end
