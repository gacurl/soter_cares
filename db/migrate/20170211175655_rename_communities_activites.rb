class RenameCommunitiesActivites < ActiveRecord::Migration[5.0]
  def change
    rename_column :community_activities, :communities_id, :community_id
    rename_column :community_dinings, :communities_id, :community_id
    rename_column :community_features, :communities_id, :community_id
    rename_column :community_license_types, :communities_id, :community_id
  end
end
