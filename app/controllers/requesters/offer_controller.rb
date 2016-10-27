class Requesters::OfferController < ApplicationController
  def update
    job = current_user.jobs.find(params[:id])
    if job.update(professional_id: params[:professional], status: 'pending')
      Rejector.mass_rejection(offer_params, current_user)
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

  private
    def offer_params
      params.permit(:professional, :id)
    end
end
