class JobsController < ApplicationController
  def new
    @job = Job.new
  end

  def create
    @job = Job.create(job_params)
  end

  private
    def job_params
      params.require(:job).permit(:title, :description, :min_price, :max_price, :skill_id)
    end
end
