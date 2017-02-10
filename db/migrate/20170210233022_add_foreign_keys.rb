class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :devices, :users
    add_foreign_key :measurements, :devices
  end
end
