class AddSeqNumToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :seq_num, :integer, default: 0, null: false
    add_index :measurements, :seq_num
  end
end
