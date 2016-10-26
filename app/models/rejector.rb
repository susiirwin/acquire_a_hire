class Rejector
  def self.send_rejection_messages(*user_rejections)
    user_rejections.each do |ur|
      rejection_message(ur)
    end
  end

  private
    def self.rejection_message(user_rejection)
      Message.create(
        subject: "AUTO-SENT MESSAGE",
        body: "Another professional was hired",
        sender_id: user_rejection.job.requester_id,
        recipient_id: user_rejection.user.id,
        job: user_rejection.job
      )
    end
end
