class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :job

  def self.find_by_job(id)
    Message.where(job_id: id).order(:created_at)
  end
end
