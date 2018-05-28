class AddModifiersToRelationships < ActiveRecord::Migration[5.0]
  def change
    add_column :relationships, :step, :boolean, default: false
    add_column :relationships, :in_law, :boolean, default: false
    add_column :relationships, :great, :boolean, default: false
  end
end
