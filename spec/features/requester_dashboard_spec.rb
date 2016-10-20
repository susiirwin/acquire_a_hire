require 'rails_helper'

describe "Requester dashboard" do
  context "unassigned jobs" do
    it "has a jobs" do
      skill = Skill.new(name: "Espionage")
      job = Job.new(
        title: "Spy on my neighbors",
        skill: skill,
        min_price: 2000,
        max_price: 5000,
        description: "I need to spy on my neighbors for reasons that are totally legit",
        status: "pending"
      )
      user = create(:requester_user)
      user.jobs << job

      login(user, requesters_login_path)

      within("div.jobs") do
        expect(page).to have_content("Spy on my neighbors")
        expect(page).to have_content("Skill: Espionage")
        expect(page).to have_content("Price: $20.0 - $50.0")
        expect(page).to have_content("I need to spy on my neighbors for reasons that")
        expect(page).to have_content("Assigned to: none")
      end
    end

    it "has many jobs" do
      user = create(:requester_user)
      jobs = create_list(:job, 2, requester: user)
      user.jobs << jobs

      login(user, requesters_login_path)

      within("div.jobs") do
        expect(page).to have_content("Job 1")
        expect(page).to have_content("Job 2")
      end
    end

    it "has an assigned job" do
      requester    = create(:requester_user)
      professional = create(:user, first_name: "Gob", last_name: "Bluth")
      job = create(:job, requester: requester, professional: professional)
      professional.roles << Role.new(name: "professional")

      login(requester, requesters_login_path)

      within('div.jobs') do
        expect(page).to have_content("Assigned to: Gob Bluth")
      end
    end
  end
end
