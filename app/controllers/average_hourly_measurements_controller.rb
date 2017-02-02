class AverageHourlyMeasurementsController < ApplicationController
  before_action :load_device, only: [:index]
  respond_to :html

  def index
    @average_hourly_measurements = @device.average_hourly_measurements.this_month
  end

  private

  def load_device
    @device = current_user.devices.find(params[:device_id])
    add_breadcrumb t("devices.index.title"), :devices
    add_breadcrumb @device.name
  end
end
