class AddIndexOnTimestampToIncomingMessage < ActiveRecord::Migration
  def change
    add_index :incoming_messages, :timestamp
  end
end
