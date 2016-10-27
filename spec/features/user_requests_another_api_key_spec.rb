require 'rails_helper'

describe 'user requests another api key' do
  it 'fills in password and description of use and gets an api key' do
    user = create(:requester_user)
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

    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit '/api/accounts/new'

    expect(page).to have_content('You already have an API key')

    check 'accept'
    fill_in 'password', with: user.password
    click_on 'Send New API Key'
    expect(page).to have_content(UserApi.last.key)
    expect(page).to have_content("Secret is: #{UserApi.last.secret}")
    expect(current_path).to eq('/api/accounts/dashboard')
    expect(UserApi.validate_user_key(old_key, user)).to be_falsey
    expect(UserApi.validate_user_key(UserApi.last.key, user)).to eq(true)
    expect(UserApi.last.user).to eq(user)
    expect(UserApi.last.description).to eq('testing key generation')
  end
end
