class RequestersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.update_attributes(role: "requester")
    if @user.save
      session[:user_id] = @user.id
      @user.update_attributes!(authy_id: AuthyService.create_user(@user))
      redirect_to confirmation_path
    else
      flash.now[:error] = @user.errors.full_messages.join(", ")
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
