class RemoveUserIdFromMeasurement < ActiveRecord::Migration
  def up
    remove_column :measurements, :user_id
  end
end
