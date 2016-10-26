require 'rails_helper'

describe 'requester gets offer from professional' do
  it 'clicks the reject offer button' do
    requester = create(:requester_user)
    professional = create(:professional_user)
    job = create(:job, requester: requester)
    ApplicationController.any_instance.stubs(:current_user).returns(requester)
    message = Message.create(
      body: "Build all the things.",
      subject: "You got the job.",
      sender_id: professional.id,
      recipient_id: requester.id,
      job_id: job.id
    )

    visit messages_path(job: job.id, with: professional.id)

    click_button 'Reject Offer'

    expect(current_path).to eq(conversations_path)

    ApplicationController.any_instance.stubs(:current_user).returns(professional)

    visit messages_path(job: job.id, with: requester.id)

    expect(page).to have_content("Another professional was hired")
    expect(page).to_not have_button("Reply")
  end
end
