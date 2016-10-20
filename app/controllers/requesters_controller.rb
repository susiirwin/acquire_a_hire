class RequestersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      session[:confirm] = false
      service = AuthyService.new(@user)
      @user.authy_id = service.create_user
      @user.save
      redirect_to requesters_confirmation_path
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
