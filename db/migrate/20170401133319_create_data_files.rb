class CreateDataFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :data_files do |t|
      t.string  :name
      t.string  :storage
      t.references :fileable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
