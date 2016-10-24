module ApplicationHelper
  def display_authorized_job_options
    if current_user.professional?
      button_to 'Send Message', new_professionals_message_path, method: :get
    else
      button_to 'Edit Job Information', edit_job_path(@job), method: :get
    end
  end
end
