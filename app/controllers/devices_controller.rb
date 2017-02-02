class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :destroy]
  respond_to :html

  def index
    @q = current_user.devices.search(params[:q])
    @q.sorts = "name ASC" if @q.sorts.empty?
    @devices = @q.result(distinct: true).page(params[:page])
    respond_with(@devices)
  end

  def destroy
    @device.destroy
    redirect_to :devices
  end

  private

  def set_device
    @device = current_user.devices.find(params[:id])
  end
end
