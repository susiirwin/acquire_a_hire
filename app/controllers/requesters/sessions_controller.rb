class Requesters::SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if is_valid_requester?(user)
      session[:user_id] = user.id
      session[:current_role] = "requester"
      redirect_to requesters_dashboard_path
    else
      flash.now[:danger] = "Username and/or Password is invalid. Try again."
      render :new
    end
  end

  def destroy
    session.clear
    flash[:info] = "You have logged out."
    redirect_to root_path
  end

  def confirm
    service = AuthyService.new(current_user)
    service.send_token
  end

  def validate
    validation = AuthyService.new(current_user)
    if validation.verify(params[:submitted_token]) == 'true'
      current_user.set_verified_true
      session[:confirm] = true
      redirect_to requesters_dashboard_path
    elsif current_user.verified
      flash[:error] = "The key you entered is incorrect.\nWe are sending you a new key now."
      redirect_to requesters_confirmation_path
    else
      current_user.destroy
      session.clear
      flash[:error] = "The key you entered is incorrect."
      redirect_to new_requester_path
    end
  end

  private
    def is_valid_requester?(user)
      user &&
      user.authenticate(params[:session][:password]) &&
      user.roles.pluck(:name).include?("requester")
    end
end
