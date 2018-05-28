class AddIndexToClinicians < ActiveRecord::Migration[5.0]
  def change
    add_index :community_clinicians, [:contact_id, :community_id], name: 'clinicians_index', unique: true
  end
end
