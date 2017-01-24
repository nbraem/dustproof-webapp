module ApplicationHelper
  def icon_text(icon, text = nil)
    if text
      raw [content_tag(:i, nil, class: "fa fa-#{icon}"), text].join(" ")
    else
      raw content_tag(:i, nil, class: "fa fa-#{icon}")
    end
  end

  def device_euis
    IncomingMessage.select(:device_eui).order(device_eui: :asc).where("device_eui IS NOT NULL").uniq.collect(&:device_eui)
  end
end
