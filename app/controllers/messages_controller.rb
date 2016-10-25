class MessagesController < ApplicationController
  def index
    @messages = current_user.messages.job_conversation(conversation_params)
  end

  private
    def conversation_params
      params.permit(:job, :with)
    end
end
