class AddUserUuidToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :user_uuid, :uuid
  end
end
