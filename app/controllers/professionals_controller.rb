class ProfessionalsController < ApplicationController
  def new
    @user = User.new
    @skills = Skill.all
  end

  def create
    @user = User.new(user_params)
    byebug
    if @user.save
      session[:user_id] = @user.id
      redirect_to professionals_dashboard_path
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :business_name,
        :email,
        :phone,
        :street_address,
        :city,
        :state,
        :zipcode,
        :password,
        :password_confirmation,
        skill_ids: []
      )
    end
end
