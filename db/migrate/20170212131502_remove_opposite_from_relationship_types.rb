class RemoveOppositeFromRelationshipTypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :relationship_types, :opposite
  end
end
