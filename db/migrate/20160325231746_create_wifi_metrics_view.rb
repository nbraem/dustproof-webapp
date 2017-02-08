class CreateWifiMetricsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW wifi_metrics AS
        SELECT row_number() OVER () AS id,
               api_key,
               sum(lost_packets) AS hourly_lost_packets,
               date_trunc('hour', timestamp) AS hourly_timestamp
            FROM incoming_messages
              WHERE transport = 'wifi'
              AND lost_packets IS NOT NULL
              AND lost_packets <= 60
              GROUP BY hourly_timestamp, api_key
              ORDER BY hourly_timestamp;
    SQL
  end

  def down
    execute "DROP VIEW wifi_metrics"
  end
end
