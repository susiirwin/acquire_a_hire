class AuthyService
  def create_user(user, country_code = 1)
#    conn = Faraday.new(url: 'https://api.authy.com/protected/json') do |faraday|
#      faraday.request :url_encoded
#      faraday.adapter Faraday.default_adapter
#    end

#    response = conn.post '/users/new' do |req|
#     req.params['api_key'] = ENV['authy_api_key']
#      req.params['user[email]'] = user.email
#      req.params['user[cellphone]'] = user.phone
#      req.params['user[country_code]'] = country_code
#    end
    response = Faraday.post("https://api.authy.com/protected/json/users/new?api_key=#{ENV['authy_api_key']}&user[email]=#{user.email}&user[cellphone]=#{user.phone}&user[country_code]=#{country_code}")

    JSON.parse(response.body, symbolize_names: true)[:user][:id].to_s
  end
end
