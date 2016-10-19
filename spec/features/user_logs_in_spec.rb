require 'rails_helper'

describe "user log in" do
  it "successfully logs in requester with proper username and password" do
    user = create(:user)

    visit requesters_login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.street_address)
    expect(current_path).to eq(requesters_dashboard_path)
  end

  it "successfully logs in professional with proper username and password" do
    user = create(:user)

    visit professionals_login_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_on "Login"

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.street_address)
    expect(current_path).to eq(professionals_dashboard_path)
  end
end
