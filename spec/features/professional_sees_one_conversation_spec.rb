require 'rails_helper'

describe 'A professional sees one of their conversations' do
  it 'shows each message in reverse chronological order' do
    requester = create(:requester_user)
    professional = create(:professional_user)
    job = create(:job, requester: requester)
    ApplicationController.any_instance.stubs(:current_user).returns(professional)


    message1 = Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job.id)
    message2 = Message.create(body: "Give me your money", subject: "I got the job", sender_id: professional.id, recipient_id: requester.id, job_id: job.id)

    visit "/messages?job=#{job.id}&with=#{requester.id}"

    within('div.message:first') do
      expect(page).to have_content(professional.business_name)
      expect(page).to have_content("Give me your money")
    end

    within('div.message:last') do
      expect(page).to have_content(requester.full_name)
      expect(page).to have_content("Build all the things.")
    end
  end
end
