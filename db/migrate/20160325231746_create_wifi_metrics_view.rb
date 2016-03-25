class CreateWifiMetricsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW wifi_metrics AS
        SELECT row_number() OVER () AS id,
               count(body) AS datapoints,
               date_trunc('hour', timestamp) AS hourly_timestamp
            FROM incoming_messages
              WHERE date_trunc('hour', timestamp) < date_trunc('hour', (now() at time zone 'utc'))
              AND transport = 'wifi'
              GROUP BY hourly_timestamp
              ORDER BY hourly_timestamp;
    SQL
  end

  def down
    execute "DROP VIEW wifi_metrics"
  end
end
