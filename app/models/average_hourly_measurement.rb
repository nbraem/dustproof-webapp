class AverageHourlyMeasurement < ActiveRecord::Base
  self.primary_key = "id"
  belongs_to :user
end
