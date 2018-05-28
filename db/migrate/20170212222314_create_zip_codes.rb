class CreateZipCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zip_codes do |t|
      t.string :code
      t.references :county, foreign_key: true

      t.timestamps
    end
  end
end
