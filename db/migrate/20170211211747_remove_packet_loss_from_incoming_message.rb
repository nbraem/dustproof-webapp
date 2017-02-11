class RemovePacketLossFromIncomingMessage < ActiveRecord::Migration
  def up
    remove_column :incoming_messages, :lost_packets
  end
end
