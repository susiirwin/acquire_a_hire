class Job < ApplicationRecord
  belongs_to :skill
  belongs_to :requester, class_name: "User"

  scope :in_progress, -> {where(status: 'pending')}
  scope :available, -> {where(status: 'available')}
  scope :closed, -> {where(status: 'closed')}
end
