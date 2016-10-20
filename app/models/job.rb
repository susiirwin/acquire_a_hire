class Job < ApplicationRecord
  belongs_to :skill
  belongs_to :requester, class_name: "User"
end
