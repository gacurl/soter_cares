class AddOppositeToRelationshipTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :relationship_types, :opposite, :string
  end
end
