class RequestersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.roles << Role.find_or_create_by(name: "requester")

    if @user.save
      session[:user_id] = @user.id
      redirect_to requesters_dashboard_path
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :phone,
        :street_address,
        :city,
        :state,
        :zipcode,
        :password,
        :password_confirmation
      )
    end
end
