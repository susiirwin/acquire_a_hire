class UserApi < ApplicationRecord
  belongs_to :user

  def overwrite_key
    update(key: UserApi.generate_key)
  end

  def self.save_key(params, uid)
    user_api = find_or_create_by(user_id: uid)
    user_api.update(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      description: params[:description],
      url: params[:url],
      redirect_url: params[:redirect_url],
      key: generate_key
    )
  end

  def self.validate_user_key(key, user)
    user.user_apis.pluck(:key).include?(key)
  end

  private
    def self.generate_key
      SecureRandom.urlsafe_base64
    end
end
