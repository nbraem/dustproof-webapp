class RenameUuidToIdOnUsersAndIncomingMessages < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :id
      t.rename :uuid, :id
    end
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"

    change_table :incoming_messages do |t|
      t.remove :id
      t.rename :uuid, :id
    end
    execute "ALTER TABLE incoming_messages ADD PRIMARY KEY (id);"
  end
end
