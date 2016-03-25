class WifiMetric < ActiveRecord::Base
  self.primary_key = "id"

  def chart_datetime
    (hourly_timestamp.to_i + 3600) * 1000 if hourly_timestamp
  end

  def datapoints_lost
    30 - datapoints if datapoints
  end
end
