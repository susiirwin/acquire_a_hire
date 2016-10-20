# class Requesters::SessionsController < ApplicationController
#   skip_before_action :persist_current_user, only: [:confirm, :validate]
#
#   def new
#   end
#
#   def create
#     user = User.find_by(email: params[:session][:email])
#     if is_valid_requester?(user)
#       session[:user_id] = user.id
#       session[:confirm] = false
#       session[:current_role] = "requester"
#       redirect_to requesters_confirmation_path
#     else
#       flash.now[:danger] = "Username and/or Password is invalid. Try again."
#       render :new
#     end
#   end
#
#   def confirm
#     service = AuthyService.new(current_user)
#     service.send_token
#   end
#
#   def validate
#     validation = AuthyService.new(current_user)
#     if validation.verify(params[:submitted_token]) == 'true'
#       current_user.set_final_parameters("requester")
#       session[:confirm] = true
#       redirect_to requesters_dashboard_path
#     elsif current_user.verified
#       too_many_incorrect_attempts
#       flash[:error] = "The key you entered is incorrect.\nWe are sending you a new key now."
#       redirect_to requesters_confirmation_path
#     else
#       current_user.destroy
#       session.clear
#       flash[:error] = "The key you entered is incorrect."
#       redirect_to new_requester_path
#     end
#   end
#
#   def destroy
#     session.clear
#     flash[:info] = "You have logged out."
#     redirect_to root_path
#   end
#
#   private
#     def is_valid_requester?(user)
#       user &&
#       user.authenticate(params[:session][:password]) &&
#       user.roles.pluck(:name).include?("requester")
#     end
#
#     def too_many_incorrect_attempts
#       session[:counter] ||= 0
#       session[:counter] += 1
#       if session[:counter] == 3
#         flash[:error] = "You entered the incorrect key too many times.\nPlease try again later."
#         redirect_to root_path
#       end
#     end
# end
