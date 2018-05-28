class CorrectLicense < ActiveRecord::Migration[5.0]
  def change
    rename_column :community_license_types, :license_types_id, :license_type_id
    add_index :community_license_types, [:license_type_id, :community_id], name: 'licenses_index', unique: true
  end
end
