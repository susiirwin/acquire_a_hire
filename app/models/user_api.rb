class UserApi < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :url, presence: true
  validates :redirect_url, presence: true

  belongs_to :user

  def overwrite_key
    update(key: UserApi.generate_key)
    update(secret: UserApi.generate_key)
  end

  def update(params)
    params[:key] = UserApi.generate_key
    super(params)
  end

  def self.validate_user_key(key, user)
    user.user_apis.pluck(:key).include?(key)
  end

  private
    def self.generate_key
      SecureRandom.urlsafe_base64
    end
end
