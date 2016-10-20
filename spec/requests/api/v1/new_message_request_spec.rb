require 'rails_helper'

describe 'New Message API Endpoint' do
  it 'sends a message' do
    requester = create(:requester)
    professional = create(:professional)
    job = create(:job, professional: professional, requester: requester)

    post "/api/v1/jobs/#{job.id}/new_message?sender=#{professional.id}"
    return_message = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(return_message).to eq("Message sent to #{requester.full_name}")
  end
end
