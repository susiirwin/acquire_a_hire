class AuthyService
  def initialize(user)
    @user = user
  end

  def create_user(country_code = 1)
    # response = conn.post '/users/new' do |req|
    #   req.params["api_key"] = ENV['authy_api_key']
    #   req.params["user[email]"] = user.email
    #   req.params["user[cellphone]"] = user.phone
    #   req.params["user[country_code]"] = country_code
    # end
    response = Faraday.post("https://api.authy.com/protected/json/users/new?api_key=#{ENV['authy_api_key']}&user[email]=#{user.email}&user[cellphone]=#{user.phone}&user[country_code]=#{country_code}")

    JSON.parse(response.body, symbolize_names: true)[:user][:id].to_s
  end

  def send_token
    response = Faraday.get("https://api.authy.com/protected/json/sms/#{user.authy_id}?api_key=#{ENV['authy_api_key']}")

    JSON.parse(response.body, symbolize_names: true)[:success]
  end

  def verify(submitted_token)
    response = Faraday.get("https://api.authy.com/protected/json/verify/#{submitted_token}/#{user.authy_id}?api_key=#{ENV['authy_api_key']}")

    JSON.parse(response.body, symbolize_names: true)[:success]
  end

  private
    attr_reader :user

    def conn
      Faraday.new(url: 'https://api.authy.com/protected/json')
    end
end
