class Professionals::SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if is_valid_professional?(user)
      session[:user_id] = user.id
      session[:current_role] = "professional"
      redirect_to professionals_dashboard_path
    else
      flash.now[:danger] = "Username and/or Password is invalid. Try again."
      render :new
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
      user.authenticate(params[:session][:password]) &&
      user.roles.pluck(:name).include?("professional")
    end
end
