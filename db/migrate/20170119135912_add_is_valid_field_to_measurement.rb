class AddIsValidFieldToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :is_valid, :boolean, default: false, null: false
  end
end
