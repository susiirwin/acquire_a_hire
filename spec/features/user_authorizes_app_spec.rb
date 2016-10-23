require 'rails_helper'

describe "User authorizes access to account" do
  it "logs in, confirms authorization and is redirected to redirect_url with code" do
    user = create(:requester_user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    UserAuthorization.any_instance.stubs(:set_code).returns("123")
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

    visit "/api/oauth/authorize?response_type=code&api_key=#{user_api.key}&redirect_url=#{user_api.redirect_url}"

    fill_in :authorization_email, with: user.email
    fill_in :authorization_password, with: user.password
    click_on "Login"

    expect(current_path).to eq("/api/oauth/authorize/confirm")

    click_on "Authorize Application"

    expect(current_path).to eq("/test_redirect_landing")
    expect(page).to have_content("code: 123")
  end
end
