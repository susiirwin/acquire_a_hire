require 'rails_helper'

describe "API endpoint for all messages" do
  context "professional" do
    it "returns an array of messages" do
      requester = create(:requester_user, first_name: "Dave", last_name: "Clancey")
      # And my user has permission to comment on this job - at this point they do.... is this ok?
      professional = create(:professional_user)
      app_user = create(:user)
      params = {
        first_name: app_user.first_name,
        last_name: app_user.last_name,
        email: app_user.email,
        description: 'testing key generation',
        url: 'http://test.com',
        redirect_url: '/test_redirect_landing'
      }
      user_api = UserApi.find_or_create_by(user_id: app_user.id)
      user_api.create_new_key(params)
      authorization = UserAuthorization.create(user: professional, user_api: user_api, authorized: true)
      token = authorization.set_token
      job = create(:job, requester: requester)
      Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job.id)
      Message.create(body: "OK. Give me all your money.", subject: "Sweet!", sender_id: professional.id, recipient_id: requester.id, job_id: job.id)
      Message.create(body: "K thx bye.", subject: "You got the job.", sender_id: requester.id, recipient_id: professional.id, job_id: job.id)

      get "/api/v1/jobs/#{job.id}/messages.json",
                      params: {token: authorization.token},
                      headers: {'Content-Type': 'application/json'}

      # And I should see a JSON response with an array of JavaScript objects
      messages = JSON.parse(response.body)

      expect(messages.count).to eq(3)
      # And each object should have a poster_id, body, and created_at

      expect(response.status).to eq(200)
      expect(messages.first).to have_key("poster_id")
      expect(messages.last["body"]).to eq("Build all the things.")
      expect(messages.first).to have_key("body")
      expect(messages.first).to have_key("created_at")
    end

    it "returns an array of related messages only" do
      requester = create(:requester, first_name: "Dave", last_name: "Clancey")
      professional = create(:professional_user)
      professional_2 = create(:professional_user)
      job = create(:job, requester: requester)
      job2 = create(:job, requester: requester)
      app_user = create(:user)
      params = {
        first_name: app_user.first_name,
        last_name: app_user.last_name,
        email: app_user.email,
        description: 'testing key generation',
        url: 'http://test.com',
        redirect_url: '/test_redirect_landing'
      }
      user_api = UserApi.find_or_create_by(user_id: app_user.id)
      user_api.create_new_key(params)
      authorization = UserAuthorization.create(user: professional, user_api: user_api, authorized: true)
      token = authorization.set_token
      Message.create(body: "Build all the things.",
                    subject: "You got the job.",
                    sender_id: requester.id,
                    recipient_id: professional.id,
                    job_id: job.id)
      Message.create(body: "OK. Give me all your money.",
                    subject: "Sweet!",
                    sender_id: professional.id,
                    recipient_id: requester.id,
                    job_id: job.id)
      Message.create(body: "K thx bye.",
                    subject: "You got the job.",
                    sender_id: requester.id,
                    recipient_id: professional.id,
                    job_id: job.id)
      Message.create(body: "I really want to help you out.",
                    subject: "Give me a chance.",
                    sender_id: requester.id,
                    recipient_id: professional.id,
                    job_id: job2.id)
      Message.create(body: "Can I build the thing?",
                    subject: "Give me a chance.",
                    sender_id: professional_2.id,
                    recipient_id: requester.id,
                    job_id: job.id)

      get "/api/v1/jobs/#{job.id}/messages.json",
                      params: {token: token},
                      headers: {'Content-Type': 'application/json'}

      messages = JSON.parse(response.body)

      expect(messages.count).to eq(3)

      expect(response.status).to eq(200)
      expect(messages.first).to have_key("poster_id")
      expect(messages.first).to have_key("body")
      expect(messages.first).to have_key("created_at")
    end
  end

  context "requester" do
    it "returns an array of messages grouped by professional_id" do
      requester = create(:requester_user, first_name: "Dave", last_name: "Clancey")
      # And my user has permission to comment on this job - at this point they do.... is this ok?
      # professionals = create_list(:professional_user, 3)
      professionals = [create(:professional_user), create(:professional_user), create(:professional_user)]
      app_user = create(:user)
      params = {
        first_name: app_user.first_name,
        last_name: app_user.last_name,
        email: app_user.email,
        description: 'testing key generation',
        url: 'http://test.com',
        redirect_url: '/test_redirect_landing'
      }
      user_api = UserApi.find_or_create_by(user_id: app_user.id)
      user_api.create_new_key(params)
      authorization = UserAuthorization.create(user: requester, user_api: user_api, authorized: true)
      token = authorization.set_token
      job = create(:job, requester: requester)
      Message.create(body: "Build all the things.", subject: "You got the job.", sender_id: requester.id, recipient_id: professionals[0].id, job_id: job.id)
      Message.create(body: "Give me all your money?", subject: "Favor?", sender_id: professionals[1].id, recipient_id: requester.id, job_id: job.id)
      Message.create(body: "K thx bye.", subject: "You got the job.", sender_id: requester.id, recipient_id: professionals[2].id, job_id: job.id)

      get "/api/v1/jobs/#{job.id}/messages.json",
                      params: {token: authorization.token},
                      headers: {'Content-Type': 'application/json'}

      # And I should see a JSON response with an array of JavaScript objects
      messages = JSON.parse(response.body)
      expect(messages.count).to eq(3)
      # And each object should have a poster_id, body, and created_at

      expect(response.status).to eq(200)
      expect(messages.first).to have_key("business_name")
      expect(messages.first).to have_key("business_id")
      expect(messages.first).to have_key("messages")
      expect(messages.first["messages"].count).to eq(1)
      expect(messages.first["messages"].first).to have_key("poster_id")
      expect(messages.first["messages"].first).to have_key("body")
      expect(messages.first["messages"].first).to have_key("created_at")
    end
  end
end
