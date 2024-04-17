class Post < ApplicationRecord
  belongs_to :gig
  belongs_to :user
  belongs_to :parent, class_name: "Post", foreign_key: "parent_id", optional: true

  validates :text, presence: true
  validates :text, length: { maximum: 512 }

  def is_reply?
    parent_id.present?
  end
end
