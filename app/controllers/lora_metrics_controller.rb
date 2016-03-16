class LoraMetricsController < ApplicationController
  respond_to :html

  def index
    @lora_metrics = LoraMetric.order("hourly_timestamp ASC")
  end
end
