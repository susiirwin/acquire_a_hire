class Api::AccountsController < ApplicationController
  def new
    @user = current_user
  end

  def create
    byebug
    if valid_form?
      UserApi.generate_key(api_request_params)
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
end

# SecureRandom.urlsafe_base64
