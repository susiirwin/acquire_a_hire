class Rejector
  def self.send_rejection_messages(user_rejections)
    user_rejections.each do |ur|
      rejection_message(ur)
    end
  end

  def self.mass_rejection(params, current_user)
    job = current_user.jobs.find(params[:id])
    job_poster = job.requester
    pro_ids = Message.where(job_id: job.id).map { |m| m.other_party(job_poster.id) }.uniq
    pro_ids.delete(params[:professional].to_i)
    pro_ids.each { |id| UserRejection.create(job: job, user_id: id)}
    rejections = UserRejection.where(job_id: job.id)
    Rejector.send_rejection_messages(rejections)
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
