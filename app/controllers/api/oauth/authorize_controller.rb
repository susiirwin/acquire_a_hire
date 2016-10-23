class Api::Oauth::AuthorizeController < ApplicationController
  def new
    @authorize_params = authorize_params
  end

  def create
    user = User.find_by(email: params[:authorization][:email])
    user_api = UserApi.find_by(key: authorize_params[:api_key])
    if user.authenticate(params[:authorization][:password]) && user_api
      session[:authorizing_user_id] = user.id
      UserAuthorization.create(user: user, user_api: user_api)
      redirect_to api_oauth_authorize_confirm_path(authorize_params)
    else
      render :new
    end
  end

  def show
    @authorize_params = authorize_params
  end

  def redirect
    user_api = UserApi.find_by(key: authorize_params[:api_key])
    code = get_code(user_api)
    redirect_to "#{user_api.redirect_url}?code=#{code}"
  end

  private
    def authorize_params
      params.permit(:response_type, :api_key, :redirect_url)
    end

    def get_code(user_api)
      user_authorization = find_user_authorization(user_api)
      user_authorization.update_attributes(authorized: true)
      code = user_authorization.set_code
    end

    def find_user_authorization(user_api)
      user = User.find(session[:authorizing_user_id])
      user_authorization = UserAuthorization.find_by(user_api: user_api, user: user)
    end
end
