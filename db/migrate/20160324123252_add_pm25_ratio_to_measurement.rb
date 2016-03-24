class AddPm25RatioToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :pm25_ratio, :float
  end
end
