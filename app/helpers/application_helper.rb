module ApplicationHelper
  def body_css
    css = ["#{controller.controller_name}-#{controller.action_name}"]
    css << 'signed-in' if user_signed_in?

    css.join(' ')
  end
end
