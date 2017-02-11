class AddIndexesToDevice < ActiveRecord::Migration
  def change
    add_index :devices, :api_key
    add_index :devices, :device_eui
  end
end
