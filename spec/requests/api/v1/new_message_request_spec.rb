require 'rails_helper'

describe 'New Message API Endpoint' do
  it 'sends a message' do
    requester = create(:requester)
    professional = create(:professional)
    job = create(:job, requester: requester)
    message_body = '{"body":"HEY PLEASE HIRE ME SUCKA"}'

    post "/api/v1/jobs/#{job.id}/new_message.json?sender=#{professional.id}&recipient=#{requester.id}", message_body, {'Content-Type': 'application/json'}

    sent = Message.last
    return_message = JSON.parse(response.body)['return_message']

    expect(response.status).to eq(200)
    expect(return_message).to eq("Message sent to #{requester.full_name}")
    expect(sent.body).to eq('HEY PLEASE HIRE ME SUCKA')
  end
end
