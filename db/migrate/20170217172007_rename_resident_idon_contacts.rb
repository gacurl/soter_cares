class RenameResidentIdonContacts < ActiveRecord::Migration[5.0]
  def change
    rename_column :contacts, :resident_id, :case_id
  end
end
