class Professionals::JobsController < ApplicationController
  def index
    @jobs = Job.for_professional(current_user)
  end
end
