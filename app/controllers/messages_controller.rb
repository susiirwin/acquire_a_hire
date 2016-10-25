class MessagesController < ApplicationController
  def index
    @messages = current_user.messages
                            .where(job_id: params[:job])
                            .where('sender_id = ? OR recipient_id = ?', params[:with], params[:with])
                            .order(created_at: :desc)
  end
end
