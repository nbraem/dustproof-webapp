require "rounded_averages_accessors"

class AverageDailyMeasurement < ActiveRecord::Base
  include RoundedAveragesAccessors

  self.primary_key = "id"
  belongs_to :user

  scope :this_month, -> { where(daily_timestamp: Date.today.beginning_of_month.to_time..Time.now) }

  def chart_datetime
    daily_timestamp.to_i * 1000 if daily_timestamp
  end
end
