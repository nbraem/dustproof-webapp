class DropCalculatedFields < ActiveRecord::Migration
  def change
    remove_column :measurements, :p1_concentration
    remove_column :measurements, :p1_concentration_filtered
    remove_column :measurements, :p2_concentration
    remove_column :measurements, :p2_concentration_filtered
  end
end
