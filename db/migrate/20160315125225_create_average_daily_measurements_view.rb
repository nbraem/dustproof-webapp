class CreateAverageDailyMeasurementsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW average_daily_measurements AS
        SELECT row_number() OVER () AS id,
               user_id,
               round(avg(temperature)::numeric, 2) AS average_temperature,
               round(avg(humidity)::numeric, 2) AS average_humidity,
               round(avg(p1_concentration)) AS average_p1_concentration,
               round(avg(p2_concentration)) AS average_p2_concentration,
               round(avg(p1_concentration_filtered)) AS average_p1_concentration_filtered,
               round(avg(p2_concentration_filtered)) AS average_p2_concentration_filtered,
               date_trunc('day', timestamp) AS daily_timestamp
            FROM measurements
              WHERE temperature IS NOT NULL
                AND humidity IS NOT NULL
                AND p1_concentration IS NOT NULL
                AND p2_concentration IS NOT NULL
                AND p1_concentration_filtered IS NOT NULL
                AND p2_concentration_filtered IS NOT NULL
              GROUP BY daily_timestamp, user_id
              ORDER BY daily_timestamp;
    SQL
  end

  def down
    execute "DROP VIEW average_daily_measurements"
  end
end
