require 'rails_helper'

describe 'New Message API Endpoint from professional' do
  it 'sends a message' do
    requester = create(:requester, first_name: "Dave", last_name: "Clancey", api_key: '4567')
    professional = create(:professional)
    params = {
      first_name: create(:user).first_name,
      last_name: create(:user).last_name,
      email: create(:user).email,
      description: 'testing key generation',
      url: 'http://test.com',
      redirect_url: '/test_redirect_landing'
    }
    user_api = UserApi.find_or_create_by(user_id: professional.id)
    user_api.create_new_key(params)
    authorization = UserAuthorization.create(user: professional, user_api: user_api)
    token = authorization.set_token
    job = create(:job, requester: requester)
    message = JSON.generate({body: "HEY PLEASE HIRE ME SUCKA", token: token, recipient_id: requester.id})
    post "/api/v1/jobs/#{job.id}/message.json",
          params: message,
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
    params = {
      first_name: create(:user).first_name,
      last_name: create(:user).last_name,
      email: create(:user).email,
      description: 'testing key generation',
      url: 'http://test.com',
      redirect_url: '/test_redirect_landing'
    }
    user_api = UserApi.find_or_create_by(user_id: professional.id)
    user_api.create_new_key(params)
    authorization = UserAuthorization.create(user: requester, user_api: user_api)
    token = authorization.set_token
    job = create(:job, requester: requester)
    message = JSON.generate({body: "HEY SUCKA! You are hired!", token: token, recipient_id: professional.id})

    post "/api/v1/jobs/#{job.id}/message.json",
          params: message,
          headers: {'Content-Type': 'application/json'}

    sent = Message.last
    return_message = JSON.parse(response.body)['return_message']

    expect(response.status).to eq(201)
    expect(return_message).to eq("Message sent to #{professional.business_name}")
    expect(sent.body).to eq('HEY SUCKA! You are hired!')
  end
end
