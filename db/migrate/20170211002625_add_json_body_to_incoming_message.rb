class AddJsonBodyToIncomingMessage < ActiveRecord::Migration
  def change
    add_column :incoming_messages, :json_body, :jsonb, null: false, default: '{}'
    add_index  :incoming_messages, :json_body, using: :gin
  end
end
