class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :seq, limit: 8
      t.float :p1_concentration
      t.float :p1_filtered
      t.integer :p1_lpo, limit: 8
      t.float :p1_ratio
      t.float :p2_concentration
      t.float :p2_filtered
      t.integer :p2_lpo, limit: 8
      t.float :p2_ratio
      t.float :humidity
      t.float :temperature
      t.integer :timestamp
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
