class Charts::MeasurementSerializer < Charts::BaseSerializer
  attributes :y, :timestamp

  def y
    object.temperature.present? ? object.temperature : nil
  end

  def timestamp
    object.timestamp.strftime("%d-%m-%Y %H:%M") if object.timestamp
  end
end
