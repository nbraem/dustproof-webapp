class AddDeviceUuidToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :device_uuid, :uuid
  end
end
