module ApplicationHelper
  def display_authorized_job_options
    if current_user.id == @job.professional_id
      button_to "Review Requester", new_review_path, method: :get, params: { job_id: params[:id] }, class: "btn-acquire"
    elsif current_user.professional?
      button_to 'Start Conversation', new_message_path, method: :get, params: { job_id: @job.id }, class: "btn-acquire"
    elsif current_user.id == @job.requester_id && @job.professional
      button_to "Review Professional", new_review_path, method: :get, params: { job_id: params[:id] }, class: "btn-acquire"
    elsif current_user.id == @job.requester_id
      button_to 'Edit Job Information', edit_job_path(@job), method: :get, class: "btn-acquire"
    end
  end

  def display_attachments(message)
    unless message.attachment.file.nil?
      link_to message.attachment.file.original_filename, message.attachment.url
    end
  end

  def display_navbar
    if current_user.nil? || !current_user.verified
      render partial: 'shared/guest_nav'
    elsif current_user.professional?
      render partial: 'shared/professional_nav'
    elsif current_user.requester?
      render partial: 'shared/requester_nav'
    end
  end

  def dashboard_by_role(user)
    return requesters_dashboard_path if user.role == "requester"
    return professionals_dashboard_path if user.role == "professional"
  end
end
