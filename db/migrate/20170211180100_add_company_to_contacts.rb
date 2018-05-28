class AddCompanyToContacts < ActiveRecord::Migration[5.0]
  def change
    add_reference :contacts, :company, foreign_key: true
  end
end
