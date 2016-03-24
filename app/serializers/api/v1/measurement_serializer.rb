class Api::V1::MeasurementSerializer < Api::V1::BaseSerializer
  attributes :id, :humidity, :temperature, :timestamp, :transport,
             :pm25_ratio,
             :p1_ratio, :p1_count,
             :p2_ratio, :p2_count

  def timestamp
    object.timestamp.in_time_zone.iso8601 if object.timestamp
  end
end
