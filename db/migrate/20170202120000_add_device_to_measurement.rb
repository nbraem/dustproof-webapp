class AddDeviceToMeasurement < ActiveRecord::Migration
  def change
    add_reference :measurements, :device, index: true, foreign_key: true
  end
end
