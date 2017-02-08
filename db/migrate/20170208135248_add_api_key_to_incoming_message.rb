class AddApiKeyToIncomingMessage < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :api_key, :string
    add_index :incoming_messages, :api_key
  end
end
