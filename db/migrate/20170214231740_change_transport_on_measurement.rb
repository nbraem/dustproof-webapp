class ChangeTransportOnMeasurement < ActiveRecord::Migration
  def change
    change_column :measurements, :transport, :string, limit: 10
  end
end
