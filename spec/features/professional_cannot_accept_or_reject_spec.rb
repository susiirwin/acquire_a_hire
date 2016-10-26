require 'rails_helper'

describe 'requester gets offer from professional' do
  it 'clicks the hire button and changes status of job' do
    requester = create(:requester_user)
    professional = create(:professional_user)
    job = create(:job, requester: requester)
    message = Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: professional.id, recipient_id: requester.id, job_id: job.id)
    ApplicationController.any_instance.stubs(:current_user).returns(professional)

    visit messages_path(job: job.id, with: requester.id)

    expect(page).to have_button("Reply")
    expect(page).to_not have_button("Accept Offer")
    expect(page).to_not have_button("Reject Offer")
  end
end
