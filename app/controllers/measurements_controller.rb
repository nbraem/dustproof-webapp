class MeasurementsController < ApplicationController
  before_action :load_device, only: [:index, :destroy_all]
  before_action :set_measurement, only: [:show, :destroy]
  respond_to :html

  def index
    @q = @device.measurements.search(params[:q])
    @q.sorts = "timestamp DESC" if @q.sorts.empty?
    @measurements = @q.result(distinct: true).page(params[:page])
    respond_with(@measurements)
  end

  def destroy
    @measurement.destroy
    redirect_to [@device, :measurements]
  end

  def destroy_all
    @device.measurements.destroy_all
    redirect_to [@device, :measurements], notice: "Alle metingen zijn verwijderd."
  end

  private

  def load_device
    @device = current_user.devices.find(params[:device_id])
    add_breadcrumb t("devices.index.title"), :devices
    add_breadcrumb @device.name
  end

  def set_measurement
    load_device
    @measurement = @device.measurements.find(params[:id])
  end
end
