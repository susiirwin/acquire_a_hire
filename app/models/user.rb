class User < ApplicationRecord
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :user_skills
  has_many :skills, through: :user_skills
end
