class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_verified_user
  helper_method :current_user
  helper_method :dashboard_by_role

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private
    def require_verified_user
      unless verified_login?
        session[:user_id] = nil
        if current_user
          current_user.destroy
        end
      end
    end

    def logged_in?
      !current_user.nil?
    end

    def verified_login?
      logged_in? && current_user.verified
    end
end
