class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_action :validate_two_auth_confirm
  before_action :persist_current_user
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private
    def validate_two_auth_confirm
      unless session[:confirm] && logged_in?

      end
    end

    def persist_current_user
      session[:user_id] = nil unless logged_in? && session[:confirm]
    end

    def logged_in?
      !current_user.nil?
    end
end
