require 'rails_helper'

describe 'professional marks a job as complete' do
  it 'clicks mark as complete and no longer sees the job on their dashboard' do
    pro = create(:professional_user)
    req = create(:requester_user)
    job = create(:job, professional: pro, requester: req, status: "pending")
    ApplicationController.any_instance.stubs(:current_user).returns(pro)
    message = Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: req.id, recipient_id: pro.id, job_id: job.id)

    visit messages_path(job: job.id, with: job.requester.id)

    expect(page).to have_button("Mark as Complete")

    click_on "Mark as Complete"

    visit professionals_dashboard_path

    expect(current_path).to eq('/professionals/dashboard')
    expect(page).to_not have_link("#{job.id} - #{job.title}")

    visit messages_path(job: job.id, with: job.requester.id)

    expect(page).to_not have_button("Mark as Complete")
  end
end
