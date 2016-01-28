module ApplicationHelper
  def icon_text(icon, text = nil)
    if text
      raw [content_tag(:i, nil, class: "fa fa-#{icon}"), text].join(" ")
    else
      raw content_tag(:i, nil, class: "fa fa-#{icon}")
    end
  end
end
