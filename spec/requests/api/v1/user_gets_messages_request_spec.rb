require 'rails_helper'

describe "API endpoint for all messages" do
  it "returns an array of messages" do
    requester = create(:requester, first_name: "Dave", last_name: "Clancey", api_key: '4567')
    # And my user has permission to comment on this job - at this point they do.... is this ok?
    professional = create(:professional, api_key: '1234')
    job = create(:job, requester: requester)
    Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job.id)
    Message.create(body: "OK. Give me all your money.", subject: "Sweet!", sender_id: professional.id, recipient_id: requester.id, job_id: job.id)
    Message.create(body: "K thx bye.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job.id)

    get "/api/v1/jobs/#{job.id}/messages.json",
                    params: '{"api_key":"4567"}',
                    headers: {'Content-Type': 'application/json'}

    messages = JSON.parse(response.body)
    expect(messages.count).to eq(3)

    expect(response.status).to eq(200)
    expect(messages.first).to have_key("poster_id")
    expect(messages.first).to have_key("body")
    expect(messages.first.body).to eq("Build all the things.")
    expect(messages.first).to have_key("created_at")
  end

  # xit "returns an array of related messages only" do
  #   requester = create(:requester, first_name: "Dave", last_name: "Clancey", api_key: '4567')
  #   # And my user has permission to comment on this job - at this point they do.... is this ok?
  #   professional = create(:professional, api_key: '1234')
  #   job1 = create(:job, id: 1, requester: requester)
  #   job2 = create(:job, id: 2, requester: requester)
  #   Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job1.id)
  #   Message.create(body: "OK. Give me all your money.", subject: "Sweet!", sender_id: professional.id, recipient_id: requester.id, job_id: job1.id)
  #   Message.create(body: "K thx bye.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job1.id)
  #   Message.create(body: "K thx bye.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job2.id)
  #
  #   get "/api/v1/jobs/#{job.id}/messages.json",
  #                   params: '{"api_key":"4567"}',
  #                   headers: {'Content-Type': 'application/json'}
  #
  #   # And I should see a JSON response with an array of JavaScript objects
  #   messages = JSON.parse(response.body)
  #   expect(messages.count).to eq(3)
  #   # And each object should have a poster_id, body, and created_at
  #   expect(response.status).to eq(200)
  #   expect(messages.first).to have_key("poster_id")
  #   expect(messages.first).to have_key("body")
  #   expect(messages.first).to have_key("created_at")
  # end
end
