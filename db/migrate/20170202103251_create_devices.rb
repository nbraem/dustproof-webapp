class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :api_key
      t.string :device_eui
      t.string :transport
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
