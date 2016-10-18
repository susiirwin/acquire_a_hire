require 'rails_helper'

describe 'guest creates requester account' do
  context 'user enters all necessary information' do
    it 'clicks sign up and creates account' do
      visit root_path
      within('div.requester') do
        click_on 'Sign Up'
      end

      fill_in 'first_name', with: 'Chad'
      fill_in 'last_name', with: 'Clancey'
      fill_in 'email', with: 'cclancey007@test.com'
      fill_in 'street_address', with: '123 Test St.'
      fill_in 'city', with: 'Denver'
      fill_in 'state', with: 'Colorado'
      fill_in 'zipcode', with: '80202'

      click_on 'Submit'

      user = User.last
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.street_address)
    end
  end
end
