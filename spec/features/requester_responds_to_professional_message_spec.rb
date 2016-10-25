require 'rails_helper'

describe 'requester replies to professional message' do
  it 'replies and sees all messages in conversation' do
    pro = create(:professional_user)
    req = create(:requester_user)
    job = create(:job, requester_id: req.id)
    message = Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: pro.id, recipient_id: req.id, job_id: job.id)
    ApplicationController.any_instance.stubs(:current_user).returns(req)

    visit messages_path(job: job.id, with: pro.id)
    click_on 'Reply'
    fill_in 'message_subject', with: 'Test Subject'
    fill_in 'message_body', with: "I'm testing my response to your message"
    click_on 'Send Message'

    expect(current_path).to eq(messages_path)
    expect(page).to have_content(req.display_name)
    expect(page).to have_content("Test Subject")
    expect(page).to have_content("I'm testing my response to your message")
    expect(page).to have_content("Build all the things.")
  end
end
