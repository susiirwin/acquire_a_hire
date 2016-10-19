require 'rails_helper'

describe "user log in" do
  it "successfully logs in requester with proper username and password" do
    user = create(:user)
    user.roles << Role.find_or_create_by(name: "requester")

    login(user, requesters_login_path)

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.street_address)
    expect(current_path).to eq(requesters_dashboard_path)
  end

  it "successfully logs in professional with proper username and password" do
    user = create(:user)
    user.roles << Role.find_or_create_by(name: "professional")

    login(user, professionals_login_path)

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.street_address)
    expect(current_path).to eq(professionals_dashboard_path)
  end

  def login(user, login_path)
    visit login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"
  end
end
