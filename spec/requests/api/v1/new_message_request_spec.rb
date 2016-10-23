require 'rails_helper'

describe 'New Message API Endpoint from professional' do
  it 'sends a message' do
    requester = create(:requester, first_name: "Dave", last_name: "Clancey", api_key: '4567')
    professional = create(:professional, api_key: '1234')
    job = create(:job, requester: requester)
    message_body = '{"body":"HEY PLEASE HIRE ME SUCKA","api_key":"1234"}'

    post "/api/v1/jobs/#{job.id}/message.json",
          params: message_body,
          headers: {'Content-Type': 'application/json'}

    sent = Message.last
    return_message = JSON.parse(response.body)['return_message']

    expect(response.status).to eq(201)
    expect(return_message).to eq("Message sent to #{requester.full_name}")
    expect(sent.body).to eq('HEY PLEASE HIRE ME SUCKA')
  end
end

describe 'New Message API Endpoint from requester' do
  it 'sends a message' do
    requester = create(:requester_user, first_name: "Dave", last_name: "Clancey", api_key: '7890')
    professional = create(:professional_user, business_name: "SUCKA EMCEEs LLC")
    job = create(:job, requester: requester)
    message_body = '{"body":"HEY SUCKA! You are hired!", "business_name":"SUCKA EMCEEs LLC", "api_key":"7890"}'


    post "/api/v1/jobs/#{job.id}/message.json",
          params: message_body,
          headers: {'Content-Type': 'application/json'}

    sent = Message.last
    return_message = JSON.parse(response.body)['return_message']

    expect(response.status).to eq(201)
    expect(return_message).to eq("Message sent to #{professional.business_name}")
    expect(sent.body).to eq('HEY SUCKA! You are hired!')
  end
end
