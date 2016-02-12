class UpdateMeasurementFields < ActiveRecord::Migration
  def change
    remove_column :measurements, :seq
    remove_column :measurements, :p1_concentration
    remove_column :measurements, :p1_filtered
    remove_column :measurements, :p1_lpo
    remove_column :measurements, :p2_concentration
    remove_column :measurements, :p2_filtered
    remove_column :measurements, :p2_lpo
    add_column :measurements, :transport, :string
    add_column :measurements, :p1_count, :integer
    add_column :measurements, :p2_count, :integer
  end
end
