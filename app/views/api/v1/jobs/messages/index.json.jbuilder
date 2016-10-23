json.array! @messages do |message|
  json.poster_id message.sender_id
  json.body message.body
  json.created_at message.created_at
end
