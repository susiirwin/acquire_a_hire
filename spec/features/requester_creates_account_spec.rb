require 'rails_helper'

describe 'guest creates requester account' do
  context 'user enters all necessary information' do
    it 'clicks sign up and creates account' do
      AuthyService.any_instance.stubs(:create_user).returns("11111")
      AuthyService.any_instance.stubs(:send_token).returns("true")
      AuthyService.any_instance.stubs(:verify).returns("true")

      visit root_path
      within('div.requester') do
        click_on 'Sign Up'
      end

      fill_in 'user_first_name', with: 'Chad'
      fill_in 'user_last_name', with: 'Clancey'
      fill_in 'user_email', with: 'cclancey007@test.com'
      fill_in 'user_phone', with: '555-555-1234'
      fill_in 'user_street_address', with: '123 Test St.'
      fill_in 'user_city', with: 'Denver'
      fill_in 'user_state', with: 'Colorado'
      fill_in 'user_zipcode', with: '80202'

      fill_in 'user_password', with: "12345"
      fill_in 'user_password_confirmation', with: "12345"

      click_on 'Create Account'

      expect(page).to have_current_path('/requesters/confirmation')
      fill_in 'submitted_token', with: '54321'
      click_on 'Submit'

      expect(current_path).to eq(requesters_dashboard_path)

      user = User.last
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.street_address)
      expect(user.roles.pluck(:name)).to include("requester")
    end
  end

  context "user enters partial info" do
    xit "returns to the new requester form" do
      visit root_path
      within('div.requester') do
        click_on 'Sign Up'
      end

      fill_in 'user_first_name', with: 'Chad'
      fill_in 'user_last_name', with: 'Clancey'
      fill_in 'user_phone', with: '555-555-1234'
      fill_in 'user_street_address', with: '123 Test St.'
      fill_in 'user_city', with: 'Denver'
      fill_in 'user_state', with: 'Colorado'
      fill_in 'user_zipcode', with: '80202'

      fill_in 'user_password', with: "12345"
      fill_in 'user_password_confirmation', with: "12345"

      click_on 'Create Account'
      expect(page).to have_button('Create Account')
    end
  end
end
