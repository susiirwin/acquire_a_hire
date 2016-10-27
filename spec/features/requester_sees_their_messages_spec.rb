require 'rails_helper'

describe 'A requester views their conversations' do
  it 'sees each seperate conversation with a professional' do
    requester = create(:requester_user)
    professional = create(:professional_user)
    job = create(:job, requester: requester)
    ApplicationController.any_instance.stubs(:current_user).returns(requester)


    Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: professional.id, recipient_id: requester.id, job_id: job.id)

    visit '/conversations'

    expect(page).to have_link("#{job.title} - #{professional.business_name}", href: "/messages?job=#{job.id}&with=#{professional.id}")
  end
end
