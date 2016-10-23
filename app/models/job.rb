class Job < ApplicationRecord
  validate :is_valid_price_range

  belongs_to :skill
  belongs_to :requester, class_name: "User"
  belongs_to :professional, class_name: "User", optional: true

  scope :in_progress, -> { where(status: "pending") }
  scope :available,   -> { where(status: "available") }
  scope :closed,      -> { where(status: "closed") }

  def assigned_professional_name
    "none"
  end
  private
    def is_valid_price_range
      if min_price > max_price
        errors.add(:min_price, "can't be greater than max price")
      end
    end
end
