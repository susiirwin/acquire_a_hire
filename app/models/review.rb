class Review < ApplicationRecord
  belongs_to :professional, class_name: "User"
  belongs_to :requester, class_name: "User"
end
