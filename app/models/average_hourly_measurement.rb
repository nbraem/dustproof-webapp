class AverageHourlyMeasurement < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :device

  scope :this_month, -> { where(hourly_timestamp: 30.days.ago.beginning_of_day..Time.now) }

  def chart_datetime
    hourly_timestamp.to_i * 1000 if hourly_timestamp
  end
end
