class DecisionMakerINdexing < ActiveRecord::Migration[5.0]
  def change
    remove_index :decision_makers, name: "unique_decision_makers"
    add_index :decision_makers, [:contact_id, :relationship_id], unique: true,
        name: "unique_dm_relationships"
    add_index :decision_makers, [:contact_id, :hierarchy], unique: true,
        name: "unique_dm_hierarchies"
  end
end
