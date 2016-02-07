class Api::V1::MeasurementSerializer < Api::V1::BaseSerializer
  attributes :id, :seq_id, :humidity, :temperature, :timestamp,
             :p1_concentration, :p1_filtered, :p1_lpo, :p1_ratio,
             :p2_concentration, :p2_filtered, :p2_lpo, :p2_ratio

  def timestamp
    object.timestamp.in_time_zone.iso8601 if object.timestamp
  end
end
