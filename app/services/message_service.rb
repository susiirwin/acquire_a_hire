class MessageService
  def initialize(job_id, api_key, business_name)
    @job_id = job_id
    @api_key = api_key
    @business_name = business_name
  end

  def create_message(body)
    Message.create(body: body,
                   sender: sender,
                   recipient: recipient,
                   job: job)
  end

  def sender
    User.find_by_api_key(@api_key)
  end

  def job
    Job.find(@job_id)
  end

  def requester
    job.requester
  end

  def recipient
    if requester == sender
      User.find_by_business_name(@business_name)
    else
      requester
    end
  end

  def display_name
    recipient.display_name
  end
end
