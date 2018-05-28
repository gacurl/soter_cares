class UniqueRelationships < ActiveRecord::Migration[5.0]
  def change
    add_index :relationships, [:contact_id, :relation_id, :relationship_type_id], unique: true,
      name: "unique_relationships"
  end
end
