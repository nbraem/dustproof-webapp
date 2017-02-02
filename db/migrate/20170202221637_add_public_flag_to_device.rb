class AddPublicFlagToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :public, :boolean, default: false
  end
end
