require 'rails_helper'

describe "Requester dashboard" do
  context "open jobs" do
    it "has a jobs" do
      skill = Skill.new(name: "Espionage")
      job = Job.new(
        title: "Spy on my neighbors",
        skill: skill,
        min_price: 2000,
        max_price: 5000,
        description: "I need to spy on my neighbors for reasons that are totally legit",
        status: "available"
      )
      user = create(:requester_user)
      user.jobs << job
      ApplicationController.any_instance.stubs(:current_user).returns(user)

      visit requesters_dashboard_path


      within("div.jobs div#open") do
        expect(page).to have_link("#{job.id} - #{job.title}")
      end
    end

    it "has many jobs" do
      user = create(:requester_user)
      jobs = create_list(:job, 2, requester: user)
      user.jobs << jobs
      ApplicationController.any_instance.stubs(:current_user).returns(user)

      visit requesters_dashboard_path

      within("div.jobs div#open") do
        expect(page).to have_link("#{jobs.first.id} - #{jobs.first.title}")
        expect(page).to have_link("#{jobs.last.id} - #{jobs.last.title}")
      end
    end
  end

  context "in progress jobs" do
    it "has an assigned job" do
      requester    = create(:requester_user)
      professional = create(:professional_user, first_name: "Gob", last_name: "Bluth")
      job = create(:job, requester: requester, professional: professional, status: "pending")
      requester.jobs << job
      ApplicationController.any_instance.stubs(:current_user).returns(requester)

      visit requesters_dashboard_path

      within('div.jobs div#in_progress') do
        expect(page).to have_link("#{job.id} - #{job.title}")
      end
    end
  end
end
