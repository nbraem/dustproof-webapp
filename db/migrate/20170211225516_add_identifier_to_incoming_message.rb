class AddIdentifierToIncomingMessage < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :identifier, :string, default: "", null: false
    add_index :incoming_messages, :identifier
  end
end
