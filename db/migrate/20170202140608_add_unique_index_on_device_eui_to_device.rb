class AddUniqueIndexOnDeviceEuiToDevice < ActiveRecord::Migration
  def change
    add_index :devices, :device_eui, unique: true
  end
end
