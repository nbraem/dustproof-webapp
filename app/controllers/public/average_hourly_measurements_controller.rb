class Public::AverageHourlyMeasurementsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_device
  respond_to :html

  def index
    @average_hourly_measurements = @device.average_hourly_measurements.this_month
  end

  private

  def load_device
    begin
      @device = Device.where(public: true).find(params[:device_id])
    rescue
      render "public/shared/device_not_found", status: :not_found
    end
  end
end
