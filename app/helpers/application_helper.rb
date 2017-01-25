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

  def dust_level
    last_measurement = current_user.measurements.select(:pm25_ratio).order(timestamp: :desc).first
    last_measurement.pm25_ratio
  end

  def dust_level_badge
    ratio = dust_level
    if ratio < 1.0
      content_tag(:span, 1, class: "label label-success")
    elsif ratio.between?(1.0, 1.99)
      content_tag(:span, 2, class: "label label-warning")
    elsif ratio.between?(2.0, 3.99)
      content_tag(:span, 3, class: "label label-warning")
    elsif ratio.between?(4.0, 5.99)
      content_tag(:span, 4, class: "label label-danger")
    elsif ratio >= 6.0
      content_tag(:span, 5, class: "label label-danger")
    end
  end

  def dust_level_color
    ratio = dust_level
    if ratio < 1.0
      "lime"
    elsif ratio.between?(1.0, 1.99)
      "orange"
    elsif ratio.between?(2.0, 3.99)
      "orange"
    elsif ratio.between?(4.0, 5.99)
      "red"
    elsif ratio >= 6.0
      "red"
    end
  end
end
