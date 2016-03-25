class WifiMetricsController < ApplicationController
  respond_to :html

  def index
    @wifi_metrics = WifiMetric.order("hourly_timestamp ASC")
  end
end
