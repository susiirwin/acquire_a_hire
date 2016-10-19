module ApplicationHelper
  def logout_path_based_on_role
    if session[:current_role] == 'professional'
      professionals_logout_path
    elsif session[:current_role] == 'requester'
      requesters_logout_path
    end
  end
end
