class AddIndexToIncomingMessagesOnDeviceui < ActiveRecord::Migration
  def change
    add_index :incoming_messages, :device_eui
  end
end
