class UserAuthorization < ApplicationRecord
  belongs_to :user
  belongs_to :user_api

  def set_code
    update_attributes(code: get_code)
    code
  end

  def set_token
    update_attributes(token: get_code)
    token
  end

  private
    def get_code
      SecureRandom.urlsafe_base64
    end
end
