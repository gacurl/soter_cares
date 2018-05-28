class AddValidToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :validated, :boolean
  end
end
