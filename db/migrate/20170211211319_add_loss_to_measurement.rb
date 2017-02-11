class AddLossToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :loss, :integer, default: 0, null: false
  end
end
