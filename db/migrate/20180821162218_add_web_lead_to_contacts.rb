class AddWebLeadToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :web_lead, :boolean, default: false
  end
end
