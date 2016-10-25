if @user_authorization
  json.access_token @user_authorization.token
  json.token_type "bearer"
  json.info do
    json.name @user_authorization.user.full_name
    json.email @user_authorization.user.email
  end
else
  json.error "Invalid request, could not find user authorization for this app"
end
