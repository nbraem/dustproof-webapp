class Public::MeasurementsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_device
  respond_to :html

  def index
    @q = @device.measurements.search(params[:q])
    @q.sorts = "timestamp DESC" if @q.sorts.empty?
    @measurements = @q.result(distinct: true).page(params[:page])
    respond_with(@measurements)
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
