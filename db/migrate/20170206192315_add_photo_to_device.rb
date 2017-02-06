class AddPhotoToDevice < ActiveRecord::Migration
  def up
    add_attachment :devices, :photo
  end

  def down
    remove_attachment :devices, :photo
  end
end
