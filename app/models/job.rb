class Job < ApplicationRecord
  validates :min_price, numericality: { less_than: :max_price, greater_than: 0 }

  belongs_to :skill
  belongs_to :requester, class_name: "User"
  belongs_to :professional, class_name: "User", optional: true

  scope :in_progress, -> { where(status: "pending") }
  scope :available,   -> { where(status: "available") }
  scope :closed,      -> { where(status: "closed") }

  def assigned_professional_name
    "none"
  end
end
