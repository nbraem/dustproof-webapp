class WifiMetricsController < ApplicationController
  respond_to :html

  def index
    @q = WifiMetric.search(params[:q])
    @q.sorts = "hourly_timestamp asc"
    @q.identifier_eq = "001AF081" if @q.identifier_eq.blank?
    @wifi_metrics = @q.result
  end
end
