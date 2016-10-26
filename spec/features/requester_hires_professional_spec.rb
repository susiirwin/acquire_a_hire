require 'rails_helper'

describe 'requester gets offer from professional' do
  it 'clicks the hire button and changes status of job' do
    requester = create(:requester_user)
    professional = create(:professional_user)
    job = create(:job, requester: requester)
    message = Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: professional.id, recipient_id: requester.id, job_id: job.id)
    ApplicationController.any_instance.stubs(:current_user).returns(requester)

    visit messages_path(job: job.id, with: professional.id)
    expect(page).to have_button('Reject Offer')
    click_on 'Accept Offer'

    expect(current_path).to eq(job_path(job))
    expect(page).to have_content("Assigned To: #{professional.business_name}")
  end
end
