class Requesters::OfferController < ApplicationController
  def update
    job = current_user.jobs.find(params[:id])
    job_poster = job.requester
    pro_ids = Message.where(job_id: job.id).map { |m| m.other_party(job_poster.id) }.uniq
    pro_ids.delete(params[:professional].to_i)
    if job.update(professional_id: params[:professional], status: 'pending')
      pro_ids.each { |id| UserRejection.create(job: job, user_id: id)}
      rejections = UserRejection.where(job_id: job.id)
      Rejector.send_rejection_messages(rejections)
      redirect_to job_path(job)
    else
      redirect_back(fallback_location: dashboard_by_role(current_user))
    end
  end

  def destroy
    job = current_user.jobs.find(params[:id])
    professional = User.find(params[:professional])
    user_rejection = UserRejection.create(job: job, user: professional)
    Rejector.send_rejection_messages([user_rejection])
    redirect_to conversations_path
  end
end
