class RemoveUniqueIndexOnDeviceEui < ActiveRecord::Migration
  def change
    remove_index :devices, :device_eui
  end
end
