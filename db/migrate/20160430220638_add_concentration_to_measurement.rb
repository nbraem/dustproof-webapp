class AddConcentrationToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :p1_concentration, :integer
    add_column :measurements, :p1_concentration_filtered, :integer

    add_column :measurements, :p2_concentration, :integer
    add_column :measurements, :p2_concentration_filtered, :integer
  end
end
