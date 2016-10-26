class TestLandingController < ApplicationController
  def show
    @code = params[:code]
  end
end
