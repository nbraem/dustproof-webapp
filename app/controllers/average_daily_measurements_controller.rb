class AverageDailyMeasurementsController < ApplicationController
  respond_to :html

  def index
    @average_daily_measurements = current_user.average_daily_measurements.this_month
  end
end
