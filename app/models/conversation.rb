class Conversation
  def initialize(raw_conversation, user_id)
    @job_id = raw_conversation[0]
    @sender_id = raw_conversation[1]
    @recipient_id = raw_conversation[2]
    @user_id = user_id
  end

  def job
    Job.find(@job_id)
  end

  def with
    if @user_id == @sender_id
      User.find(@recipient_id)
    else
      User.find(@sender_id)
    end
  end
end
