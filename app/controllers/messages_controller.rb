class MessagesController < ApplicationController
  def index
    @messages = current_user.messages.job_conversation(conversation_params)
    @job_id = params[:job]
    @with_id = params[:with]
  end

  def new
    @job = Job.find(params[:job_id])
    session[:job_id] = @job.id
    session[:recipient_id] = params[:with] || @job.requester_id
    @message = Message.new
  end

  def create
    message = Message.new(message_params)
    if message.save
      clear_params_session
      redirect_to messages_path(job: message.job_id, with: message.recipient_id)
    else
      redirect_to new_message_path
    end
  end

  private
    def conversation_params
      params.permit(:job, :with)
    end

    def message_params
      {
        subject: params[:message][:subject],
        body: params[:message][:body],
        attachment: params[:message][:attachment],
        sender_id: current_user.id,
        recipient_id: session[:recipient_id],
        job_id: session[:job_id]
      }
    end

    def clear_params_session
      session[:recipient_id] = nil
      session[:job_id] = nil
    end
end
