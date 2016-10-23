class UserAuthorization < ApplicationRecord
  belongs_to :user
  belongs_to :user_api

  def set_code
    update_attributes(code: get_code)
    code
  end

  private
    def get_code
      SecureRandom.urlsafe_base64
    end
end
