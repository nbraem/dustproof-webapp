class CreateLoraMetricsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW lora_metrics AS
        SELECT row_number() OVER () AS id,
               device_eui,
               sum(lost_packets) AS hourly_lost_packets,
               date_trunc('hour', timestamp) AS hourly_timestamp
            FROM incoming_messages
              WHERE transport = 'lora'
              AND lost_packets IS NOT NULL
              AND lost_packets <= 60
              GROUP BY hourly_timestamp, device_eui
              ORDER BY hourly_timestamp;
    SQL
  end

  def down
    execute "DROP VIEW lora_metrics"
  end
end
