class Gig < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :links, dependent: :destroy
  accepts_nested_attributes_for :links, reject_if: proc { |attributes| attributes["url"].blank? }

  validates :summary, :start_date, :location, presence: true
  validate :end_after_start

  def end_after_start
    errors.add(:end_date, "must be after start date") unless end_date >= start_date
  end

  def multimonth?
    end_date.present? && end_date.strftime("%m%y") != start_date.strftime("%m%y")
  end
end
