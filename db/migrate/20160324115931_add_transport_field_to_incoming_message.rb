class AddTransportFieldToIncomingMessage < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :transport, :string
    add_index :incoming_messages, :transport
  end
end
