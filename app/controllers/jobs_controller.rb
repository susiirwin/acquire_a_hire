class JobsController < ApplicationController
  before_action :validate_authorization

  def show
    @user = current_user
    @job = Job.find(params[:id])
  end

  private
    def validate_authorization
      unless authorized?
        render file: 'public/404.html', status: :not_found, layout: false
      end
    end

    def authorized?
      current_user.professional? || current_user.jobs.pluck(:id).include?(params[:id])
    end
end
