class SessionsController < ApplicationController
  skip_before_action :require_verified_user, only: [:confirm, :validate]
  before_action :check_attempt_number, only: [:validate]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if authenticated?(user)
      session[:user_id] = user.id
      redirect_to confirmation_path
    else
      flash.now[:danger] = "Username and/or Password is invalid. Try again."
      render :new
    end
  end

  def confirm
    service = AuthyService.new(current_user)
    unless params[:no_send]
      service.send_token
      session[:counter] = nil
    end
  end

  def validate
    validation = AuthyService.new(current_user)
    if validation.verify(params[:submitted_token]) == "true"
      current_user.update_attributes!(verified: true)
      redirect_to dashboard_by_role(current_user)
    else
      flash[:error] = "The key you entered is incorrect."
      redirect_to confirmation_path(no_send: true)
    end
  end

  def destroy
    session.clear
    flash[:info] = "You have logged out"
    redirect_to root_path
  end

  private
    def authenticated?(user)
      user.authenticate(params[:session][:password])
    end

    def check_attempt_number
      session[:counter] ||= 0
      session[:counter] +=  1
      if session[:counter] > 3
         flash[:error] = "The key you entered is incorrect.\n Too many attempts, sending new key."
         redirect_to confirmation_path
      end
    end
end
