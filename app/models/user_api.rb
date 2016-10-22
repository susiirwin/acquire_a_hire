class UserApi < ApplicationRecord
  def self.save_key(params, uid)
    user_api = find_or_create_by(uid: uid)
    user_api.update(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      description: params[:description],
      url: params[:url],
      key: generate_key
    )
  end

  private
    def self.generate_key
      SecureRandom.urlsafe_base64
    end
end
