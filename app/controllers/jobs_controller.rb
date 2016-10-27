class JobsController < ApplicationController
  before_action :validate_authorization, only: [:show]

  def new
    @job = Job.new
  end

  def create
    @job = Job.create(formatted_job_params)

    if @job.save
      flash[:info] = "Project created"
      redirect_to requesters_dashboard_path
    else
      flash[:error] = "Job does not have required fields"
      render :new
    end
  end

  def show
    @user = current_user
    @job = Job.find(params[:id])
  end

  def update
    job = Job.find(params[:id])
    if job.professional == current_user
      job.update(status: "closed")
    else
      redirect_to dashboard_by_role(current_user)
    end
  end

  private
    def validate_authorization
      unless authorized?
        render file: 'public/404.html', status: :not_found, layout: false
      end
    end

    def authorized?
      current_user.professional? ||
      current_user.jobs.pluck(:id).include?(params[:id].to_i)
    end

    def job_params
      params.require(:job).permit(:title, :description, :min_price, :max_price, :skill_id)
    end

    def formatted_job_params
      params = job_params
      params["min_price"] = params["min_price"].to_i * 100
      params["max_price"] = params["max_price"].to_i * 100
      params["requester"] = current_user
      params["state"]     = current_user.state
      params
    end
end
