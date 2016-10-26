require 'rails_helper'

describe "A user uploads a pdf" do
  it "shows the pdf on the message index page" do
    requester = create(:requester_user)
    professional = create(:professional_user)
    job = create(:job, requester: requester)
    ApplicationController.any_instance.stubs(:current_user).returns(professional)

    visit new_message_path(job_id: job.id)
    attach_file('message[attachment]', File.absolute_path('./spec/fixtures/example_pdf.pdf'))
    click_on 'Send Message'
  
    expect(Message.last.attachment.file).to_not eq(nil)
    expect(page).to have_link("example_pdf.pdf", href: "/uploads/message/#{Message.last.id}/example_pdf.pdf")
    
    `rm -rf public/uploads/message/`
  end
end
