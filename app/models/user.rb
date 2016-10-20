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

  def set_final_parameters(role)
    unless verified
      self.verified = true
      self.roles << Role.find_or_create_by(name: role)
      self.save!
    end
  end

  def clear_professional_skills
    self.user_skills.each do |us|
      us.destroy
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{street_address}\n#{city} #{state} #{zipcode}"
  end
end
