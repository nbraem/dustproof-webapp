class LoraMetricsController < ApplicationController
  respond_to :html

  def index
    @lora_metrics = LoraMetric.where(device_eui: current_user.device_eui).order("hourly_timestamp ASC")
  end
end
