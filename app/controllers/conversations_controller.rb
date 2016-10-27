class ConversationsController < ApplicationController
  def index
    @conversations = Message.summary(current_user.id).uniq
  end
end
