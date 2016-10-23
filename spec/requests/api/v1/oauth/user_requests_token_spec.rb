require 'rails_helper'

describe "OAuth API" do
  it "user requests a token by sending key, secret and code" do
    user = create(:requester_user)
    UserAuthorization.any_instance.stubs(:get_code).returns("123")
    params = {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      description: 'testing key generation',
      url: 'http://test.com',
      redirect_url: '/test_redirect_landing'
    }
    user_api = UserApi.find_or_create_by(user_id: user.id)
    user_api.update(params)
    user_authorization = UserAuthorization.create(user: user, user_api: user_api, authorized: true)
    user_authorization.set_code

    get "/api/v1/oauth/token?api_key=#{user_api.key}&secret=#{user_api.secret}&code=#{user_authorization.code}&redirect_url=#{user_api.redirect_url}"

    token_data = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(201)
    expect(token_data[:token_type]).to eq("bearer")
    expect(token_data[:info]).to eq({name: "#{user.full_name}", email: "#{user.email}"})
    expect(token_data[:access_token]).to eq("123")
  end

  it "fails if wrong info is sent" do
    user = create(:requester_user)
    params = {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      description: 'testing key generation',
      url: 'http://test.com',
      redirect_url: '/test_redirect_landing'
    }
    user_api = UserApi.find_or_create_by(user_id: user.id)
    user_api.update(params)
    user_authorization = UserAuthorization.create(user: user, user_api: user_api, authorized: true)
    user_authorization.set_code
    bad_url_1 = "/api/v1/oauth/token?api_key='123'&secret=#{user_api.secret}&code=#{user_authorization.code}&redirect_url=#{user_api.redirect_url}"
    bad_url_2 = "/api/v1/oauth/token?api_key='#{user_api.key}'&secret='123'&code=#{user_authorization.code}&redirect_url=#{user_api.redirect_url}"
    bad_url_3 = "/api/v1/oauth/token?api_key='#{user_api.key}'&secret=#{user_api.secret}&code='123'&redirect_url=#{user_api.redirect_url}"
    bad_url_4 = "/api/v1/oauth/token?api_key='#{user_api.key}'&secret=#{user_api.secret}&code=#{user_authorization.code}&redirect_url=google.com"
    bad_urls = [bad_url_1, bad_url_2, bad_url_3, bad_url_4]

    bad_urls.each do |bad_url|
      get bad_url
      data = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(403)
      expect(data[:error]).to eq("Invalid request, could not find user authorization for this app")
    end
  end
end
