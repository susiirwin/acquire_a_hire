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
  has_many :jobs, foreign_key: 'requester_id'

  def create_professional
    if valid? && !skills.empty?
      save
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{street_address}\n#{city} #{state} #{zipcode}"
  end
end
