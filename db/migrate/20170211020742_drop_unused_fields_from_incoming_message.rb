class DropUnusedFieldsFromIncomingMessage < ActiveRecord::Migration
  def up
    # add_column :incoming_messages, :identifier, :string, default: "", null: false
    # remove_column :incoming_messages, :gateway_eui
    # remove_column :incoming_messages, :tmst
    # remove_column :incoming_messages, :frequency
    # remove_column :incoming_messages, :data_rate
    # remove_column :incoming_messages, :rssi
    # remove_column :incoming_messages, :snr
    # remove_column :incoming_messages, :data
    # remove_column :incoming_messages, :packet_time
    # remove_column :incoming_messages, :api_key
    # remove_column :incoming_messages, :device_eui
    remove_column :incoming_messages, :status
    remove_column :incoming_messages, :comments
    remove_column :incoming_messages, :transport
    add_index :incoming_messages, :identifier, unique: true
  end
end
