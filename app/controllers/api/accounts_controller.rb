class Api::AccountsController < ApplicationController
  def new
    @user = current_user
  end

  def create
    @user = current_user
    if valid_form?
      UserApi.save_key(api_request_params, @user.id)
      flash[:success] = "API Key Request Accepted"
      redirect_to api_accounts_dashboard_path
    else
      flash.now[:error] = set_error_message.join(", ")
      render :new
    end
  end

  def show
    @user_api = UserApi.find_by(uid: current_user.id)
  end

  def overwrite

  end


  private
    def valid_form?
      !params[:first_name].nil? &&
      !params[:last_name].nil? &&
      !params[:email].nil? &&
      !params[:url].nil? &&
      !params[:redirect_url].nil? &&
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
      errors << "Application URL can't be blank" if params[:url].nil?
      errors << "Redirect URL can't be blank" if params[:redirect_url].nil?
      errors << "You entered the incorrect password" if params[:password] != current_user.password
    end
end

# SecureRandom.urlsafe_base64
