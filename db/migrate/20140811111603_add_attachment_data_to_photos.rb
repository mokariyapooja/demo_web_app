class AddAttachmentDataToPhotos < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.attachment :data
    end
  end

  def self.down
    remove_attachment :photos, :data
  end
end
