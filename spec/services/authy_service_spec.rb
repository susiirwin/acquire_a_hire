require 'rails_helper'

describe 'Authy service' do
  it 'generates an authy id for a user' do
    VCR.use_cassette('authy#generate') do
      user = create(:user, phone: ENV['test_phone_number'])
      authy = AuthyService.new(user)

      response = authy.create_user
      expect(response).to eq(ENV['user_authy_id'])
    end
  end

  it 'sends a code to a user' do
    VCR.use_cassette('authy#send') do
      user = create(:user, authy_id: ENV['user_authy_id'])
      authy = AuthyService.new(user)

      response = authy.send_token

      expect(response).to eq(true)
    end
  end

  it "verifies a user's code" do
    VCR.use_cassette('authy#verify') do
      user = create(:user, authy_id: ENV['user_authy_id'])
      authy = AuthyService.new(user)

      # The value passed to verify is what the user inputs into the form
      response = authy.verify(ENV['user_authy_token'])

      expect(response).to eq("true")
    end
  end
end
