require 'rails_helper'

describe 'Authy service' do
  it 'generates an authy id for a user' do
    VCR.use_cassette('authy#generate') do
      user = create(:user, phone: ENV['test_phone_number']) 
      authy = AuthyService.new

      response = authy.create_user(user)
      expect(response).to eq(ENV['user_authy_id'])
    end
  end

  it 'sends a code to a user' do
    VCR.use_cassette('authy#send') do

    end
  end

  it "verifies a user's code" do
  end
end
