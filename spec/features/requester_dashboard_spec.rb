require 'rails_helper'

describe "Requester dashboard" do
  it "has jobs" do
    skill = Skill.new(name: "Espionage")
    job = Job.new(title: "Spy on my neighbors", skill: skill, min_price: 2000, max_price: 5000, description: "I need to spy on my neighbors for reasons that are totally legit", status: "pending")
    user = create(:user)
    user.jobs << job

    login(user, requesters_login_path)

    within("div.jobs") do
      expect(page).to have_content("Spy on my neighbors")
      expect(page).to have_content("Skill: Espionage")
      expect(page).to have_content("Price: $20 - $50")
      expect(page).to have_content("I need to spy on my neighbors for reasons that...")
      expect(page).to have_content("Assigned to: none")
    end
  end
end
