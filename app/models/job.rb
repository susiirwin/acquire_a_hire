class Job < ApplicationRecord
  belongs_to :skill
  belongs_to :requester, class_name: "User"

  def assigned_professional_name
    "none"
  end
end
