require 'rails_helper'

describe "Professional dashboard" do
  context "current jobs" do
    it "shows all in progress jobs assigned to me" do
      pro = create(:professional_user)
      job = create(:job, professional: pro, requester: create(:requester_user), status: "pending")
      ApplicationController.any_instance.stubs(:current_user).returns(pro)

      visit professionals_dashboard_path

        expect(page).to have_link("#{job.id} - #{job.title}")

    end

    it "only shows assigned jobs" do
      pro = create(:professional_user)
      job = create(:job, professional: pro, requester: create(:requester_user), status: "foo")
      ApplicationController.any_instance.stubs(:current_user).returns(pro)

      visit professionals_dashboard_path

      expect(page).to_not have_link("#{job.id} - #{job.title}")

    end
  end
end
