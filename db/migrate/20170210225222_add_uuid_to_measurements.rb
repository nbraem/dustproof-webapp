class AddUuidToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :uuid, :uuid, default: "uuid_generate_v4()", null: false
  end
end
