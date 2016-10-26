class Requesters::OfferController < ApplicationController
  def update
    job = current_user.jobs.find(params[:id])
    if job.update(professional_id: params[:professional], status: 'pending')
      redirect_to job_path(job)
    else
      redirect_back(fallback_location: dashboard_by_role(current_user))
    end
  end

  def destroy
  end
end
