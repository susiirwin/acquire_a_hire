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
    user_api = UserApi.find_or_create_by(user_id: user.id)
    user_api.create_new_key(params)

    expect(UserApi.last.key.length).to eq(22)
    expect(UserApi.last.user).to eq(user)
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
      url: 'http://test.com',
      redirect_url: 'http://test.com'
    }
    user_api = UserApi.find_or_create_by(user_id: user.id)
    user_api.update(params)

    expect(UserApi.validate_user_key(UserApi.last.key, user)).to eq(true)
    expect(UserApi.validate_user_key(11111, user)).to be_falsey
  end

  it 'overwrites existing keys' do
    user = create(:user)
    params = {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      description: 'testing key generation',
      url: 'http://test.com',
      redirect_url: 'http://test.com'
    }
    user_api = UserApi.find_or_create_by(user_id: user.id)
    user_api.update(params)
    old_key = UserApi.last.key
    UserApi.last.overwrite_key

    expect(UserApi.validate_user_key(old_key, user)).to be_falsey
    expect(UserApi.validate_user_key(UserApi.last.key, user)).to eq(true)
    expect(old_key).to_not eq(UserApi.last.key)
  end
end
