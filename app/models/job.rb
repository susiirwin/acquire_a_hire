class Job < ApplicationRecord
  validates :title,       presence: true
  validates :skill,       presence: true
  validates :description, presence: true
  validates :status,      presence: true
  validates :min_price, numericality: { greater_than: 0, less_than: :max_price }

  belongs_to :skill
  belongs_to :requester, class_name: "User"
  belongs_to :professional, class_name: "User", optional: true

  scope :in_progress, -> { where(status: "pending") }
  scope :available,   -> { where(status: "available") }
  scope :closed,      -> { where(status: "closed") }

  def self.for_professional(professional)
    where(state: professional.state).where(skill: [professional.skills.pluck('id')])
  end
end
