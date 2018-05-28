class ModifyRelatioships < ActiveRecord::Migration[5.0]
  def change
    remove_column :relationships, :relatable_type, :string
    remove_column :relationships, :relatable_id, :integer
    add_reference :relationships, :contact
    add_column    :relationships, :relation_id, :integer
  end
end
