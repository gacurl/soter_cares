class AddEntanglesToRelationshipTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :relationship_types, :entanglement, :string
  end
end
