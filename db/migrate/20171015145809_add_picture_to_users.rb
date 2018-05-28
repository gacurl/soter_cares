class AddPictureToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pic_link, :string
  end
end
