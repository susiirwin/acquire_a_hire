require 'rails_helper'

RSpec.describe UserApi, type: :model do
  it 'generates api key' do
    user = create(:user)
    params = {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      description: 'testing key generation',
      url: 'http://test.com',
      redirect_url: 'http://test.com'
    }
    UserApi.save_key(params, user.id)

    expect(UserApi.last.key.length).to eq(22)
    expect(UserApi.last.uid).to eq(user.id)
    expect(UserApi.last.first_name).to eq(user.first_name)
    expect(UserApi.last.last_name).to eq(user.last_name)
    expect(UserApi.last.email).to eq(user.email)
    expect(UserApi.last.description).to eq(params[:description])
    expect(UserApi.last.url).to eq(params[:url])
  end

  it 'validates existing api key with user' do
    user = create(:user)
    params = {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      description: 'testing key generation',
      url: 'http://test.com'
    }
    UserApi.save_key(params, user.id)

    expect(UserApi.validate_user_key(UserApi.last.key, user.id)).to eq(true)
    expect(UserApi.validate_user_key(11111, user.id)).to be_falsey
    expect(UserApi.validate_user_key(UserApi.last.key, 11111111)).to be_falsey
  end
end
