class Api::V1::Jobs::MessagesController < ApplicationController
  swagger_controller :messages, 'Messages'

  swagger_api :create do
    summary 'Sends a message'
    notes 'Some notes'
  end

  def create
    sender = User.find(params[:sender])
    recipient = User.find(params[:recipient])
    job = Job.find(params[:job_id])

    Message.create!(body: params[:body], sender: sender, recipient: recipient, job: job)
    @recipient = recipient
  end
end
