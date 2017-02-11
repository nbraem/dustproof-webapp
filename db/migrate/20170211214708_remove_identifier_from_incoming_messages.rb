class RemoveIdentifierFromIncomingMessages < ActiveRecord::Migration
  def up
    remove_column :incoming_messages, :identifier
  end
end
