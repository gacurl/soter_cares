class AddCodeToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :phone_code, :string
  end
end
