require 'rails_helper'

describe "user log out" do
  it "successfully logs out" do
    user = create(:user)

    visit login_path

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_on "log in"

    click_on "Log out"

    expect(page).to have_content("log in")
    expect(page).to_not have_content(user.first_name)
    expect(page).to_not have_content(user.last_name)
    expect(page).to_not have_content(user.street_address)
  end
end
