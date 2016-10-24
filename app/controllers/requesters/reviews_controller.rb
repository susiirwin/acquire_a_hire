class Requesters::ReviewsController < ApplicationController
  def new
    @review = Review.new
    @requester = current_user
  end



end
