require 'rails_helper'

describe 'professional edits account' do
  context 'enters all necessary information' do
    it 'clicks edit account and sees updates' do
      pro = create_professional
      original_skill = pro.skills.last
      create_skill
      new_skill = Skill.last

      ApplicationController.any_instance.stubs(:current_user).returns(pro)

      visit professionals_dashboard_path

      click_on 'Edit Account'
      check "skill-#{new_skill.id}"
      click_on 'Save Changes'

      expect(page).to have_content(pro.first_name)
      expect(page).to have_content(pro.last_name)
      expect(page).to have_content(pro.street_address)
      expect(page).to have_content(pro.business_name)
      expect(pro.skills.count).to eq(2)
      expect(page).to have_content(original_skill.name)
      expect(page).to have_content(new_skill.name)
    end
  end

  context "user enters partial info" do
    it "returns to the edit form if all skills are unchecked" do
      pro = create_professional
      skill = pro.skills.last

      ApplicationController.any_instance.stubs(:current_user).returns(pro)

      visit professionals_dashboard_path

      click_on 'Edit Account'
      uncheck "skill-#{skill.id}"
      click_on 'Save Changes'

      expect(page).to have_button('Create Account')
      expect(page).to have_content('You must select at least one skill')
    end
  end
end
