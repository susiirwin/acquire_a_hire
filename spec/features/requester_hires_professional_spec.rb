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

  it 'clicks the hire button and other professionals are rejected' do
    requester = create(:requester_user)
    professional_1 = create(:professional_user)
    professional_2 = create(:professional_user)
    professional_3 = create(:professional_user)
    rejected_professionals = [professional_2, professional_3]
    job = create(:job, requester: requester)
    ApplicationController.any_instance.stubs(:current_user).returns(requester)
    Message.create(body: "I build all the things.", subject: "Can I Haz Job?", sender_id: professional_1.id, recipient_id: requester.id, job_id: job.id)
    Message.create(body: "No, I build all the things.", subject: "I Wants Job.", sender_id: professional_2.id, recipient_id: requester.id, job_id: job.id)
    Message.create(body: "I build all the things + 1.", subject: "JOAB!", sender_id: professional_3.id, recipient_id: requester.id, job_id: job.id)
    visit messages_path(job: job.id, with: professional_1.id)
    expect(page).to have_button('Reject Offer')
    click_on 'Accept Offer'

    rejected_professionals.each do |pro|
      ApplicationController.any_instance.stubs(:current_user).returns(pro)

      visit messages_path(job: job.id, with: requester.id)

      expect(page).to have_content("Another professional was hired")
      expect(page).to_not have_button("Reply")
    end
  end
end
