class AddOrientToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :orient, :integer
    add_column :photos, :viewable, :boolean, default: false
  end
end
