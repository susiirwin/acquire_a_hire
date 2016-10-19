require 'rails_helper'

describe "user log in" do
  it "successfully logs in with proper username and password" do
    user = create(:user)

    visit login_path

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_on "log in"

    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.street_address)
  end
end
