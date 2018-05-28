class AddIndexToProspects < ActiveRecord::Migration[5.0]
  def change
    add_index :prospective_communities, [:contact_id, :community_id], name: 'prospects_index', unique: true
  end
end
