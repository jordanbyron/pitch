class UserDecorator < Draper::Decorator
  delegate_all

  def friendly_greeting
    hour = Time.now.hour
    greeting = if hour < 12
      "Good morning"
    elsif hour > 12 && hour < 17
      "Good afternoon"
    else
      "Good evening"
    end

    [greeting, h.link_to(model.first_name, "#")].join(' ').html_safe
  end
end
