class CreateAverageDailyMeasurementsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW average_daily_measurements AS
        SELECT row_number() OVER () AS id,
               user_id,
               avg(temperature) AS average_temperature,
               avg(humidity) AS average_humidity,
               avg(pm25_ratio) AS average_pm25_ratio,
               avg(p1_ratio) AS average_p1_ratio,
               avg(p1_count) AS average_p1_count,
               avg(p2_ratio) AS average_p2_ratio,
               avg(p2_count) AS average_p2_count,
               date_trunc('day', timestamp) AS daily_timestamp
            FROM measurements
              WHERE temperature IS NOT NULL
                AND humidity IS NOT NULL
                AND pm25_ratio IS NOT NULL
                AND p1_ratio IS NOT NULL
                AND p1_count IS NOT NULL
                AND p2_ratio IS NOT NULL
                AND p2_count IS NOT NULL
              GROUP BY daily_timestamp, user_id
              ORDER BY daily_timestamp;
    SQL
  end

  def down
    execute "DROP VIEW average_daily_measurements"
  end
end
