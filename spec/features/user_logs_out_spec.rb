require 'rails_helper'

describe "user log out" do
  it "successfully logs out a requester" do
    user = create(:requester_user)

    login(user)

    expect(page).to have_current_path('/confirmation')
    fill_in 'submitted_token', with: '54321'
    click_on 'Submit'

    click_on "Logout"

    expect(page).to have_content("Login")
    expect(page).to_not have_content(user.first_name)
    expect(page).to_not have_content(user.last_name)
    expect(page).to_not have_content(user.street_address)
  end

  it "successfully logs out a professional" do
    user = create(:professional_user)

    login(user)

    expect(page).to have_current_path('/confirmation')
    fill_in 'submitted_token', with: '54321'
    click_on 'Submit'

    click_on "Logout"

    expect(page).to have_content("Login")
    expect(page).to_not have_content(user.first_name)
    expect(page).to_not have_content(user.last_name)
    expect(page).to_not have_content(user.street_address)
  end
end
