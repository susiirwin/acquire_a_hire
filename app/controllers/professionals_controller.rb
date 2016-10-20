class ProfessionalsController < ApplicationController
  before_action :set_skills

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.create_professional
      session[:user_id] = @user.id
      session[:confirm] = false
      @user.roles << Role.new(name: "professional")
      service = AuthyService.new(@user)
      @user.authy_id = service.create_user
      @user.save
      redirect_to confirmation_path
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
      redirect_to dashboard_by_role
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

    # def dashboard_by_role
    #   return professionals_dashboard_path if
    # end

    def set_skills
      @skills = Skill.all
    end

    def set_flash_errors
      if user_params[:skill_ids].nil?
        flash.now[:alert] = @user.errors.full_messages.push('You must select at least one skill').join(', ')
      else
        flash.now[:alert] = @user.errors.full_messages.join(', ')
      end
    end
end
