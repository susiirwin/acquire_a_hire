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
      user = create(:user)
      user.roles << Role.new(name: "requester")
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
      skill_1 = Skill.new(name: "Espionage")
      skill_2 = Skill.new(name: "Housekeeping")
      job_1 = Job.new(
        title: "Spy on my neighbors",
        skill: skill_1,
        min_price: 2000,
        max_price: 5000,
        description: "I need to spy on my neighbors for reasons that are totally legit",
        status: "pending"
      )

      job_2 = Job.new(
        title: "Do my laundry",
        skill: skill_2,
        min_price: 1000,
        max_price: 2000,
        description: "PLEASE DO MY LAUNDRY, I AM TOO LAZY TO DO IT",
        status: "pending"
      )
      user = create(:user)
      user.roles << Role.new(name: "requester")
      user.jobs << job_1
      user.jobs << job_2

      login(user, requesters_login_path)

      within("div.jobs") do
        expect(page).to have_content("Spy on my neighbors")
        expect(page).to have_content("Do my laundry")
      end
    end
  end
end
