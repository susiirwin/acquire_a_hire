class Professionals::JobsController < ApplicationController
  def index
    @jobs = Job.for_professional(current_user)
  end

  def show
    @job = Job.find(params[:id])
  end

end
