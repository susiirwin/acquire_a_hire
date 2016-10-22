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
    job = Job.find(params[:job_id])
    sender = User.find_by_api_key(params[:api_key])
    requester = job.requester
    if requester == sender
      recipient = User.find_by_business_name(params[:business_name])
    else
      recipient = requester
    end
    @name = if recipient.role == "professional"
              recipient.business_name
            else
              recipient.full_name
            end
    Message.create!(body: params[:body], sender: sender, recipient: recipient, job: job)
    render status: 201
  end

  def index
    messages = Message.all
    # require 'pry'; binding.pry
    render status: 200
  end
end
