class AddIndexes < ActiveRecord::Migration
  def change
    add_index :devices, :user_id
    add_index :measurements, :device_id
  end
end
