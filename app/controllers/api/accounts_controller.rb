class Api::AccountsController < ApplicationController
  def new
    @user = current_user
  end

  def create
    byebug
    if valid_form?
      UserApi.save_key(api_request_params, current_user.id)
      redirect_to api_accounts_dashboard_path
    else
      flash.now[:error] = set_error_message.joins(", ")
      render :new
    end
  end

  def show
  end

  private
    def valid_form?
      !params[:first_name].nil? &&
      !params[:last_name].nil? &&
      !params[:email].nil? &&
      params[:password] == current_user.password
    end

    def api_request_params
      params.permit(:first_name, :last_name, :email, :description, :url)
    end

    def set_error_message
      errors = Array.new
      errors << "First Name can't be blank" if params[:first_name].nil?
      errors << "Last Name can't be blank" if params[:last_name].nil?
      errors << "Email Address can't be blank" if params[:email].nil?
      errors << "You entered the incorrect password" if params[:password] != current_user.password
    end
end

# SecureRandom.urlsafe_base64
