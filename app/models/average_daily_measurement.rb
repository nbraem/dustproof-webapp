class AverageDailyMeasurement < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :device

  scope :this_month, -> { where(daily_timestamp: 30.days.ago.beginning_of_day..Time.now) }

  def chart_datetime
    daily_timestamp.to_i * 1000 if daily_timestamp
  end
end
