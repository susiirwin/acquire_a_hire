class AuthyService
  def initialize(user)
    @user = user
  end

  def create_user(country_code = 1)
    response = conn.post do |req|
      req.url "/protected/json/users/new"
      req.params['api_key'] = "#{ENV['authy_api_key']}"
      req.params["user[email]"] = user.email
      req.params["user[cellphone]"] = user.phone
      req.params["user[country_code]"] = country_code
    end

    JSON.parse(response.body, symbolize_names: true)[:user][:id].to_s
  end

  def self.create_user(user)
    authy = AuthyService.new(user)
    authy.create_user
  end

  def send_token
    response = conn.get do |req|
      req.url "/protected/json/sms/#{user.authy_id}"
      req.params['api_key'] = "#{ENV['authy_api_key']}"
    end

    JSON.parse(response.body, symbolize_names: true)[:success]
  end

  def verify(submitted_token)
    response = conn.get do |req|
      req.url "/protected/json/verify/#{submitted_token}/#{user.authy_id}"
      req.params['api_key'] = "#{ENV['authy_api_key']}"
    end

    JSON.parse(response.body, symbolize_names: true)[:success]
  end

  private
    attr_reader :user

    def conn
      Faraday.new(:url => 'https://api.authy.com') do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end
end
