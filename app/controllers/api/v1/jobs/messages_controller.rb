class Api::V1::Jobs::MessagesController < ApplicationController
  swagger_controller :messages, 'Messages'

  swagger_api :create do
    summary 'Send a message to a user'
    notes 'Create a new message'
    param :query, :subject, :string, :required
    param :query, :body, :string, :required
    param :query, :recipient_id, :integer, :required
    param :query, :token, :string, :required
  end

  swagger_api :index do
    summary 'View all Messages in a Conversation'
    notes 'Displays array of messages related to a job.'\
          'If the requesting user is a professional, this will show the conversation they had with the job owner'\
          'If the requesting user is a requester, this will show all the conversations with professionals about that job'
    param :query, :token, :string, :required
  end

  def create
    job = Job.find(params[:job_id])
    sender = UserAuthorization.find_by(token: params[:token]).user
    recipient = User.find(params[:recipient_id])
    @name = recipient_name(recipient)
    Message.create!(
      body: params[:body],
      subject: params[:subject],
      sender: sender,
      recipient: recipient,
      job: job
    )

    render status: 201
  end

  def index
    @requesting_user = UserAuthorization.find_by(token: params[:token]).user
    messages = @requesting_user.messages.job_conversation(conversation_params)
    if @requesting_user.role == "professional"
      @messages = messages
    elsif @requesting_user.role == "requester"
      @messages = messages.group_by{ |message| message.other_party(@requesting_user.id) }
    end
    render status: 200
  end

  private
    def conversation_params
      { job: params[:job_id], with: @requesting_user.id }
    end

    def recipient_name(recipient)
      if recipient.role == "professional"
        recipient.business_name
      else
        recipient.full_name
      end
    end
end
