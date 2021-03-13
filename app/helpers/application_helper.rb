module ApplicationHelper
  def active_sidebar_link controllers, current_controller
    controllers.include?(current_controller) ? 'active' : ''
  end
end
