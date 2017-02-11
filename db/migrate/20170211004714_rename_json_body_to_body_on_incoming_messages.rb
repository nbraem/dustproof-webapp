class RenameJsonBodyToBodyOnIncomingMessages < ActiveRecord::Migration
  def change
    remove_index :incoming_messages, :json_body
    remove_column :incoming_messages, :body
    rename_column :incoming_messages, :json_body, :body
    add_index :incoming_messages, :body, using: :gin
  end
end
