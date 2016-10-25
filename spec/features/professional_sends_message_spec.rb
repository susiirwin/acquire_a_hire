require 'rails_helper'

describe 'professional sends message to requester through job show page' do
  it 'sends the message and sees the sent message' do
    pro = create(:professional_user)
    req = create(:requester_user)
    job = create(:job, requester_id: req.id)
    ApplicationController.any_instance.stubs(:current_user).returns(pro)

    visit job_path(job)
    click_on 'Send Message'
    fill_in 'message_subject', with: 'Test Subject'
    fill_in 'message_body', with: "I'm interested in your test job"
    click_on 'Send Message'

    expect(current_path).to eq(messages_path)
    expect(page).to have_content(pro.business_name)
    expect(page).to have_content("Test Subject")
    expect(page).to have_content("I'm interested in your test job")
  end
end
