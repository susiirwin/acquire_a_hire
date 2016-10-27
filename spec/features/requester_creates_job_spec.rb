require 'rails_helper'

describe "requester creates job" do
  it "clicks create project and submits details" do
    user = create(:requester_user)
    skill = create(:skill)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit requesters_dashboard_path

    click_on "Start A Project"

    fill_in "job_title", with: "do a thing"
    fill_in "job_description", with: "I need a thing done"
    fill_in "job_min_price", with: "10"
    fill_in "job_max_price", with: "20"
    select "Espionage", from: "job_skill_id"

    click_on "Create Project"

    job = Job.last
    expect(current_path).to eq(requesters_dashboard_path)
    expect(job.min_price).to eq(1000)
    expect(page).to have_link("#{job.id} - #{job.title}")

  end
end
