class CreateIncomingMessages < ActiveRecord::Migration
  def change
    create_table :incoming_messages do |t|
      t.text :body
      t.string :status

      t.timestamps null: false
    end
  end
end
