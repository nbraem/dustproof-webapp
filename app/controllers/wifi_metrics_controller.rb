class WifiMetricsController < ApplicationController
  respond_to :html

  def index
    @q = WifiMetric.search(params[:q])
    @q.sorts = "hourly_timestamp asc"
    @q.api_key_eq = "1859931b8915f2d2c85862a519067be2afb3997f" if @q.api_key_eq.blank?
    @wifi_metrics = @q.result
  end
end
