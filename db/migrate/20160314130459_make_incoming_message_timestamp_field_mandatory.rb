class MakeIncomingMessageTimestampFieldMandatory < ActiveRecord::Migration
  def change
    change_column :incoming_messages, :timestamp, :datetime, null: false
  end
end
