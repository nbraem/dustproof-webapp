class LossesController < ApplicationController
  before_action :require_admin
  respond_to :html

  def index
    @q = Loss.search(params[:q])
    @q.sorts = "hourly_timestamp asc"
    @q.device_id_eq = Device.first.id if @q.device_id_eq.blank?
    @losses = @q.result
  end
end
