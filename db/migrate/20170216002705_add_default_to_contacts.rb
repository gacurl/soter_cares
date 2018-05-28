class AddDefaultToContacts < ActiveRecord::Migration[5.0]
  def change
    change_column :contacts, :deceased, :boolean, default: false
  end
end
