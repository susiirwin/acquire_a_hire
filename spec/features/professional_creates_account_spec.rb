require 'rails_helper'

describe 'guest creates professional account' do
  context 'user enters all necessary information' do
    it 'clicks sign up and creates account' do
      AuthyService.any_instance.stubs(:create_user).returns("11111")
      AuthyService.any_instance.stubs(:send_token).returns("true")
      AuthyService.any_instance.stubs(:verify).returns("true")

      skill = Skill.create(name: "Espionage")
      visit root_path
      within('div.professional') do
        click_on 'Sign Up'
      end

      # expect(current_path).to eq("users/new")

      fill_in 'user_first_name', with: 'Chad'
      fill_in 'user_last_name', with: 'Clancey'
      fill_in 'user_business_name', with: 'Clancey Spies'
      fill_in 'user_email', with: 'cclancey007@test.com'
      fill_in 'user_phone', with: '555-555-1234'
      fill_in 'user_street_address', with: '123 Test St.'
      fill_in 'user_city', with: 'Denver'
      fill_in 'user_state', with: 'Colorado'
      fill_in 'user_zipcode', with: '80202'
      fill_in 'user_password', with: "12345"
      fill_in 'user_password_confirmation', with: "12345"
      check "skill-#{skill.id}"

      click_on 'Create Account'
      expect(page).to have_current_path('/confirmation')
      fill_in 'submitted_token', with: '54321'
      click_on 'Submit'

      user = User.last
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.street_address)
      expect(page).to have_content(user.business_name)
      expect(page).to have_content(skill.name)
      expect(user.role).to eq("professional")
      expect(user.verified).to be(true)
    end
  end

  context "user enters partial info" do
    it "returns to the new professional form" do
      skill = Skill.create(name: "Espionage")
      visit root_path
      within('div.professional') do
        click_on 'Sign Up'
      end

      fill_in 'user_first_name', with: 'Chad'
      fill_in 'user_last_name', with: 'Clancey'
      fill_in 'user_phone', with: '555-555-1234'
      fill_in 'user_street_address', with: '123 Test St.'
      fill_in 'user_state', with: 'Colorado'
      fill_in 'user_zipcode', with: '80202'
      fill_in 'user_password', with: "12345"
      fill_in 'user_password_confirmation', with: "12345"
      check "skill-#{skill.id}"

      click_on 'Create Account'
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to_not have_content('You must select at least one skill')
      expect(page).to have_button('Create Account')
    end

    it 'returns to the new professional form if no skills are selected' do
      Skill.create(name: "Espionage")
      visit root_path
      within('div.professional') do
        click_on 'Sign Up'
      end

      fill_in 'user_first_name', with: 'Chad'
      fill_in 'user_last_name', with: 'Clancey'
      fill_in 'user_business_name', with: 'Clancey Spies'
      fill_in 'user_email', with: 'cclancey007@test.com'
      fill_in 'user_phone', with: '555-555-1234'
      fill_in 'user_street_address', with: '123 Test St.'
      fill_in 'user_city', with: 'Denver'
      fill_in 'user_state', with: 'Colorado'
      fill_in 'user_zipcode', with: '80202'
      fill_in 'user_password', with: "12345"
      fill_in 'user_password_confirmation', with: "12345"

      click_on 'Create Account'
      expect(page).to have_button('Create Account')
      expect(page).to have_content('You must select at least one skill')
    end
  end

  context 'professional user enters incorrect 2-auth key' do
    it 'clicks sign up and creates account' do
      AuthyService.any_instance.stubs(:create_user).returns("11111")
      AuthyService.any_instance.stubs(:send_token).returns("true")
      AuthyService.any_instance.stubs(:verify).returns("false")

      skill = Skill.create(name: "Espionage")

      visit root_path
      within('div.professional') do
        click_on 'Sign Up'
      end

      fill_in 'user_first_name', with: 'Chad'
      fill_in 'user_last_name', with: 'Clancey'
      fill_in 'user_business_name', with: 'Clancey Spies'
      fill_in 'user_email', with: 'cclancey007@test.com'
      fill_in 'user_phone', with: '555-555-1234'
      fill_in 'user_street_address', with: '123 Test St.'
      fill_in 'user_city', with: 'Denver'
      fill_in 'user_state', with: 'Colorado'
      fill_in 'user_zipcode', with: '80202'
      fill_in 'user_password', with: "12345"
      fill_in 'user_password_confirmation', with: "12345"
      check "skill-#{skill.id}"

      click_on 'Create Account'

      expect(page).to have_current_path('/confirmation')
      fill_in 'submitted_token', with: '54321'
      click_on 'Submit'

      expect(current_path).to eq(confirmation_path)

      expect(page).to have_content('The key you entered is incorrect')
    end

    it "sends too many attempts" do
      user = create(:professional_user, :unverified)
      AuthyService.any_instance.stubs(:create_user).returns("11111")
      AuthyService.any_instance.stubs(:send_token).returns("true")
      AuthyService.any_instance.stubs(:verify).returns("false")
      ApplicationController.any_instance.stubs(:current_user).returns(user)

      visit confirmation_path

      3.times do
        expect(current_path).to include('/confirmation')
        fill_in 'submitted_token', with: '54321'
        click_on 'Submit'

        expect(current_path).to eq(confirmation_path)
        expect(page).to have_content('The key you entered is incorrect')
        expect(page).to_not have_content('Too many attempts, sending new key')
      end

      fill_in 'submitted_token', with: '54321'
      click_on 'Submit'

      expect(page).to have_content('Too many attempts, sending new key')
    end
  end

  context "user hasn't finished authy verification" do
    it "destroys temporary user if they leave confirmation" do
      user = create(:professional_user, :unverified)
      AuthyService.any_instance.stubs(:send_token).returns("true")
      ApplicationController.any_instance.stubs(:current_user).returns(user)

      visit confirmation_path

      expect(User.count).to eq(1)

      visit root_path

      expect(User.count).to eq(0)
    end
  end
end
