require 'rails_helper'

describe "user log in" do
  it "successfully logs in requester with proper username and password" do
    AuthyService.any_instance.stubs(:create_user).returns("11111")
    AuthyService.any_instance.stubs(:send_token).returns("true")
    AuthyService.any_instance.stubs(:verify).returns("true")

    user = create(:user)
    user.roles << Role.find_or_create_by(name: "requester")

    visit requesters_login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"

    expect(page).to have_current_path('/requesters/confirmation')
    fill_in 'submitted_token', with: '54321'
    click_on 'Submit'

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.street_address)
    expect(current_path).to eq(requesters_dashboard_path)
  end

  it "successfully logs in professional with proper username and password" do
    AuthyService.any_instance.stubs(:create_user).returns("11111")
    AuthyService.any_instance.stubs(:send_token).returns("true")
    AuthyService.any_instance.stubs(:verify).returns("true")

    user = create(:user)
    user.roles << Role.find_or_create_by(name: "professional")

    visit professionals_login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"

    expect(page).to have_current_path('/professionals/confirmation')
    fill_in 'submitted_token', with: '54321'
    click_on 'Submit'

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.street_address)
    expect(current_path).to eq(professionals_dashboard_path)
  end

  def login(login_path)
    visit login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"
  end
end
