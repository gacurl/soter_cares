class AddResidentIdToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :resident_id, :string
    add_index :contacts, :resident_id, unique: true
  end
end
