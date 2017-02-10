class AddUuidToIncomingMessages < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :uuid, :uuid, default: "uuid_generate_v4()", null: false
  end
end
