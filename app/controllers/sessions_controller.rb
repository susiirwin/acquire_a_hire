class SessionsController < ApplicationController
  skip_before_action :persist_current_user, only: [:confirm, :validate]
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if is_valid_professional?(user)
      session[:user_id] = user.id
      redirect_to confirmation_path
    else
      flash.now[:danger] = "Username and/or Password is invalid. Try again."
      render :new
    end
  end

  def confirm
    service = AuthyService.new(current_user)
    unless params[:do_not_send_token]
      service.send_token
    end
  end

  def validate
    validation = AuthyService.new(current_user)
    if validation.verify(params[:submitted_token]) == "true"
      current_user.update_attributes!(verified: true)
      redirect_to dashboard_by_role(current_user)
    else
      flash[:error] = "The key you entered is incorrect."
      redirect_to confirmation_path(do_not_send_token: true)
    end
  end

  def destroy
    session.clear
    flash[:info] = "You have logged out"
    redirect_to root_path
  end

  private
    def is_valid_professional?(user)
      user &&
      user.authenticate(params[:session][:password])
      # user.roles.pluck(:name).include?("professional")
    end

    def dashboard_by_role(user)
      return requesters_dashboard_path if user.role == "requester"
      return professionals_dashboard_path if user.role == "professional"
    end

    def too_many_incorrect_attempts
      session[:counter] ||= 0
      session[:counter] += 1
      if session[:counter] == 3
        flash[:error] = "You entered the incorrect key too many times.\nPlease try again later."
        redirect_to root_path
      end
    end
end
