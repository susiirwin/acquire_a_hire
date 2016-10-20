require 'rails_helper'

describe "user log out" do
  it "successfully logs out a requester" do
    user = create(:user)
    user.roles << Role.find_or_create_by(name: "requester")

    login(user, requesters_login_path)

    expect(page).to have_current_path('/requesters/confirmation')
    fill_in 'submitted_token', with: '54321'
    click_on 'Submit'

    click_on "Logout"

    expect(page).to have_content("Login")
    expect(page).to_not have_content(user.first_name)
    expect(page).to_not have_content(user.last_name)
    expect(page).to_not have_content(user.street_address)
  end

  it "successfully logs out a professional" do
    user = create(:user)
    user.roles << Role.find_or_create_by(name: "professional")

    login(user, professionals_login_path)

    expect(page).to have_current_path('/professionals/confirmation')
    fill_in 'submitted_token', with: '54321'
    click_on 'Submit'

    click_on "Logout"

    expect(page).to have_content("Login")
    expect(page).to_not have_content(user.first_name)
    expect(page).to_not have_content(user.last_name)
    expect(page).to_not have_content(user.street_address)
  end
end
