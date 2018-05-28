class AddFileDataToDataFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :data_files, :file_data, :string
  end
end
