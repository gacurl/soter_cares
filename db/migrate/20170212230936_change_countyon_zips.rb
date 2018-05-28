class ChangeCountyonZips < ActiveRecord::Migration[5.0]
  def change
    remove_column :zip_codes, :county_id
    add_reference :zip_codes, :city, foreign_key: true
  end
end
