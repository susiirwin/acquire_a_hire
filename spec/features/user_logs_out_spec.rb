require 'rails_helper'

describe "user log out" do
  it "successfully logs out a requester" do
    user = create(:user)
    user.roles << Role.find_or_create_by(name: "requester")

    visit requesters_login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"

    click_on "Logout"

    expect(page).to have_content("Login")
    expect(page).to_not have_content(user.first_name)
    expect(page).to_not have_content(user.last_name)
    expect(page).to_not have_content(user.street_address)
  end

  it "successfully logs out a professional" do
    user = create(:user)
    user.roles << Role.find_or_create_by(name: "professional")

    visit professionals_login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"

    click_on "Logout"

    expect(page).to have_content("Login")
    expect(page).to_not have_content(user.first_name)
    expect(page).to_not have_content(user.last_name)
    expect(page).to_not have_content(user.street_address)
  end
end
