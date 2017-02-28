class RemoveDeviceEuiAndApiKeyFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :device_eui, :api_key
  end
end
