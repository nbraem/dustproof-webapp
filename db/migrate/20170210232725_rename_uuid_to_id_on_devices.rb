class RenameUuidToIdOnDevices < ActiveRecord::Migration
  def change
    change_table :devices do |t|
      t.remove :id
      t.rename :uuid, :id
      t.remove :user_id
      t.rename :user_uuid, :user_id
    end
    execute "ALTER TABLE devices ADD PRIMARY KEY (id);"
  end
end
