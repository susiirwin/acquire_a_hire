if @requesting_user.role == "professional"
  json.array! @messages do |message|
    json.poster_id message.sender_id
    json.body message.body
    json.created_at message.created_at
  end
elsif @requesting_user.role == "requester"
  json.array! @messages do |pro_id, messages|
    json.business_name User.find(pro_id).business_name
    json.business_id User.find(pro_id).id
    json.messages do
      json.array! messages do |message|
        json.poster_id message.sender_id
        json.body message.body
        json.created_at message.created_at
      end
    end
  end
end
