module ApplicationHelper
  def icon_text(icon, text = nil)
    if text
      raw [content_tag(:i, nil, class: "fa fa-#{icon}"), text].join(" ")
    else
      raw content_tag(:i, nil, class: "fa fa-#{icon}")
    end
  end

  def active?(controller_name)
    controller.controller_name == controller_name ? "active" : nil
  end

  def identifiers
    IncomingMessage.select(:identifier).order(identifier: :asc).where("identifier IS NOT NULL").uniq.collect(&:identifier)
  end

  def dust_level(device)
    last_measurement = device.measurements.select(:pm25_ratio).order(timestamp: :desc).first
    last_measurement.pm25_ratio if last_measurement
  end

  def dust_level_badge(device)
    ratio = dust_level(device)
    if ratio
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
    else
      "geen metingen"
    end
  end

  def dust_level_color(device)
    ratio = dust_level(device)
    if ratio
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
end
