class RenameUuidToIdOnMeasurements < ActiveRecord::Migration
  def change
    execute "DROP VIEW average_daily_measurements"
    execute "DROP VIEW average_hourly_measurements"

    change_table :measurements do |t|
      t.remove :id
      t.rename :uuid, :id
      t.remove :device_id
      t.rename :device_uuid, :device_id
    end
    execute "ALTER TABLE measurements ADD PRIMARY KEY (id);"
  end
end
