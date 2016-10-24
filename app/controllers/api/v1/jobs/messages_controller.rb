class Api::V1::Jobs::MessagesController < ApplicationController
  swagger_controller :messages, 'Messages'

  swagger_api :create do
    summary 'Send a message to a user'
    notes 'Create a new message. business_name is required for Requester but not for Professional.'
  end

  swagger_api :index do
    summary 'View all Messages in a Conversation'
    notes 'Displays array of messages related to a job'
  end

  def create
    service = MessageService.new(params[:job_id], params[:api_key], params[:business_name])
    service.create_message(params[:body])
    @name = service.display_name
    render status: 201
  end

  def index
    @messages = Message.find_by_job(params[:job_id])
    render status: 200
  end

end
