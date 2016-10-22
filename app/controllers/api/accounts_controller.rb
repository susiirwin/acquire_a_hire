class Api::AccountsController < ApplicationController
  def new
    @user = current_user
  end

  def create
  end

  def show
  end
end

# SecureRandom.urlsafe_base64
