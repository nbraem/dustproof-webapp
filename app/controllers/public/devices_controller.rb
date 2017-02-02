class Public::DevicesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_device
  respond_to :html

  def show
    @measurements = @device.measurements.where(is_valid: true).order(timestamp: :desc).limit(4000).reverse
    respond_with(@measurements)
  end

  private

  def load_device
    begin
      @device = Device.where(public: true).find(params[:id])
    rescue
      render "public/shared/device_not_found", status: :not_found
    end
  end
end
