class Api::AccountsController < ApplicationController
  def new
    @user = current_user
  end

  def create
    @user = current_user
    @user_api = UserApi.find_or_create_by(user_id: @user.id)
    if valid_password? && @user_api.update(api_request_params)
      flash[:success] = "API Key Request Accepted"
      redirect_to api_accounts_dashboard_path
    else
      flash.now[:error] = set_error_message
      render :new
    end
  end

  def update
    @user = current_user
    @user_api = UserApi.find_by(user_id: @user.id)
    if valid_password? && params[:accept]
      overwrite_user_api_key
    else
      flash.now[:error] = set_error_message
      render :new
    end
  end

  def show
    @user_api = current_user.user_apis.last
  end

  private
    def valid_password?
      params[:password] == current_user.password
    end

    def api_request_params
      params.permit(:first_name, :last_name, :email, :description, :url, :redirect_url)
    end

    def set_error_message
      if params[:password] != current_user.password
        flash.now[:alert] = @user.errors.full_messages.push('You entered the incorrect password').join(', ')
      else
        flash.now[:alert] = @user.errors.full_messages.join(', ')
      end
    end

    def overwrite_user_api_key
      @user.user_apis.last.overwrite_key
      flash[:success] = "Your old API key has been successfully overwritten"
      redirect_to api_accounts_dashboard_path
    end
end