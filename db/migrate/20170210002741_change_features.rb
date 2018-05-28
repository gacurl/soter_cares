class ChangeFeatures < ActiveRecord::Migration[5.0]
  def change
    rename_table :community_featuress, :community_features
    rename_column :community_clinicians, :clinician_id, :contact_id
  end
end
