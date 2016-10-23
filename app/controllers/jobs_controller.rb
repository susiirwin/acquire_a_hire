class JobsController < ApplicationController
  def new
    @job = Job.new
  end

  def create
    @job = Job.create(formatted_job_params.merge(requester: current_user))

    if @job.save
      flash[:info] = "Project created"
      redirect_to requesters_dashboard_path
    else
      flash[:error] = "Job does not have required fields"
      render :new
    end
  end

  private
    def job_params
      params.require(:job).permit(:title, :description, :min_price, :max_price, :skill_id)
    end

    def formatted_job_params
      params = job_params
      params["min_price"] = params["min_price"].to_i * 100
      params["max_price"] = params["max_price"].to_i * 100
      params
    end
end
