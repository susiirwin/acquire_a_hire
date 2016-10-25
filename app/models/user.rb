class User < ApplicationRecord
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validate  :professionals_must_have_skills

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :jobs, foreign_key: 'requester_id'
  has_many :user_apis

  enum role: [:requester, :professional , :admin]


  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    if role == "professional"
      return business_name
    else
      return full_name
    end
  end

  def full_address
    "#{street_address}\n#{city} #{state} #{zipcode}"
  end

  def has_api_key?
    !user_apis.empty?
  end

  def in_progress_jobs
    jobs.in_progress
  end

  def open_jobs
    jobs.available
  end

  def closed_jobs
    jobs.closed
  end

  def messages
    Message.where('sender_id = ? OR recipient_id = ?', self.id, self.id)
  end

  private
    def professionals_must_have_skills
      if self.role == "professional" && self.skills.empty?
        errors.add(:user, "can't be professional without skills")
      end
    end
end
