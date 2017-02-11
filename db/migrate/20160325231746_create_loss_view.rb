class CreateLossView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW losses AS
        SELECT row_number() OVER () AS id,
               device_id,
               sum(loss) AS hourly_loss,
               date_trunc('hour', timestamp) AS hourly_timestamp
            FROM measurements
              GROUP BY hourly_timestamp, device_id
              ORDER BY hourly_timestamp;
    SQL
  end

  def down
    execute "DROP VIEW losses"
  end
end
