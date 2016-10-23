class Professionals::JobsController < ApplicationController
  def index
    @jobs = Job.where(state: current_user.state)
               .where(skill: [current_user.skills.pluck('id')])
  end
end
