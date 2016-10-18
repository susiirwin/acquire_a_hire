class ProfessionalsController < ApplicationController
  before_action :set_skills

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.roles << Role.find_or_create_by(name: 'professional')

    if @user.create_professional
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

    def set_skills
      @skills = Skill.all
    end
end
