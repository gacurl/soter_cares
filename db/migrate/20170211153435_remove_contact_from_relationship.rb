class RemoveContactFromRelationship < ActiveRecord::Migration[5.0]
  def change
    remove_column :relationships, :contact_id
  end
end
