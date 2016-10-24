require 'rails_helper'

describe 'A professional views their conversations' do
  it 'sees each seperate conversation with a requester' do
    requester = create(:requester_user)
    professional = create(:professional_user)
    job = create(:job, requester: requester)
    ApplicationController.any_instance.stubs(:current_user).returns(professional)

    
    Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job.id)

    visit '/conversations' 

    expect(page).to have_link("#{job.title} - #{requester.full_name}", href: "/messages?job=#{job.id}&with=#{requester.id}")
  end
end
