class LoraMetric < ActiveRecord::Base
  self.primary_key = "id"

  def chart_datetime
    hourly_timestamp.to_i * 1000 if hourly_timestamp
  end
end
