require "rounded_averages_accessors"

class AverageHourlyMeasurement < ActiveRecord::Base
  include RoundedAveragesAccessors

  self.primary_key = "id"
  belongs_to :user

  scope :this_month, -> { where(hourly_timestamp: Date.today.beginning_of_month.to_time..Time.now) }

  def chart_datetime
    hourly_timestamp.to_i * 1000 if hourly_timestamp
  end
end
