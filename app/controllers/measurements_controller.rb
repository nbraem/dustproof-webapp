class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:destroy]
  respond_to :html

  def index
    @q = current_user.measurements.search(params[:q])
    @q.sorts = "timestamp desc" if @q.sorts.empty?
    @measurements = @q.result(distinct: true).page(params[:page])
    respond_with(@measurements)
  end

  def destroy
    @measurement.destroy
    redirect_to :measurements
  end

  def destroy_all
    current_user.measurements.destroy_all
    redirect_to :measurements, notice: "Alle metingen zijn verwijderd."
  end

  private

  def set_measurement
    @measurement = current_user.measurements.find(params[:id])
  end
end