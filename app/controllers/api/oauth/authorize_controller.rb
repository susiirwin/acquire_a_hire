class Api::Oauth::AuthorizeController < ApplicationController
  def new
    @authorize_params = authorize_params
  end

  def create
    user = User.find_by(email: params[:authorization][:email])
    if user.authenticate(params[:authorization][:password])
      redirect_to api_oauth_authorize_confirm_path(authorize_params)
    else
      render :new
    end
  end

  def show
    @authorize_params = authorize_params
    # @user_api = UserApi.find_by(user: current_user)
  end

  def redirect
    user_api = UserApi.find_by(key: authorize_params[:api_key])
    redirect_to "#{user_api.redirect_url}?code=123"
  end

  private
    def authorize_params
      params.permit(:response_type, :api_key, :redirect_url)
    end
end
