class CreateAverageHourlyMeasurementsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW average_hourly_measurements AS
        SELECT
          row_number() OVER () AS id,
          user_id,
          avg(temperature) AS average_temperature,
          avg(humidity) AS average_humidity,
          avg(p1_ratio) AS average_p1_ratio,
          avg(p1_count) AS average_p1_count,
          avg(p2_ratio) AS average_p2_ratio,
          avg(p2_count) AS average_p2_count,
          date_trunc('hour', timestamp) AS hourly_timestamp
        FROM
          measurements
        GROUP BY
          user_id,
          hourly_timestamp
        ORDER BY
          hourly_timestamp;
    SQL
  end

  def down
    execute "DROP VIEW average_hourly_measurements"
  end
end
