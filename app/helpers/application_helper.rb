module ApplicationHelper
  def display_authorized_job_options
    if current_user.professional?
      button_to 'Send Message', new_professionals_message_path, method: :get
    else
      button_to 'Edit Job Information', edit_job_path(@job), method: :get
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
end
