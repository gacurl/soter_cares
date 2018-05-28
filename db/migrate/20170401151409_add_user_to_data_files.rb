class AddUserToDataFiles < ActiveRecord::Migration[5.0]
  def change
    add_reference :data_files, :user, foreign_key: true
  end
end
