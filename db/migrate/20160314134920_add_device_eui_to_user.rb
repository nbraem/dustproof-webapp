class AddDeviceEuiToUser < ActiveRecord::Migration
  def change
    add_column :users, :device_eui, :string
    add_index :users, :device_eui
  end
end
