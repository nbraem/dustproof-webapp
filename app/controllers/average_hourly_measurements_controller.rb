class AverageHourlyMeasurementsController < ApplicationController
  respond_to :html

  def index
    @average_hourly_measurements = current_user.average_hourly_measurements.this_month
  end
end
