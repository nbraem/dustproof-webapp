class LoraMetricsController < ApplicationController
  respond_to :html

  def index
    @q = LoraMetric.search(params[:q])
    @q.sorts = "hourly_timestamp asc"
    @q.device_eui_eq = "001AF081" if @q.device_eui_eq.blank?
    @lora_metrics = @q.result
  end
end
