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
      set_flash_errors
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if !user_params[:skill_ids].nil? && @user.update(user_params)
      redirect_to professionals_dashboard_path
    else
      set_flash_errors
      render :edit
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

    def set_flash_errors
      if params[:skill_ids].nil?
        flash.now[:alert] = @user.errors.full_messages.push('You must select at least one skill').join(', ')
      else
        flash.now[:alert] = @user.errors.full_messages.join(', ')
      end
    end
end
