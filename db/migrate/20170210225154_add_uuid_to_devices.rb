class AddUuidToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :uuid, :uuid, default: "uuid_generate_v4()", null: false
  end
end
