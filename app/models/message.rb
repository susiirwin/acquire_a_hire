
class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :job

  mount_uploader :attachment, AttachmentUploader

  def self.find_by_job(id)
    Message.where(job_id: id).order(:created_at)
  end

  def self.summary(user_id)
    conversations = Message.where('sender_id = ? OR recipient_id = ?', user_id, user_id).distinct.pluck(:job_id, :sender_id, :recipient_id)
    conversations.map do |raw_conversation|
      Conversation.new(raw_conversation, user_id)
    end
  end

  def self.job_conversation(conversation_params)
    where(job_id: conversation_params[:job])
    .where('sender_id = ? OR recipient_id = ?', conversation_params[:with], conversation_params[:with])
    .order(created_at: :desc)
  end

  def other_party(id)
    if sender_id == id.to_i
      recipient_id
    else recipient_id == id.to_i
      sender_id
    end
  end
end
