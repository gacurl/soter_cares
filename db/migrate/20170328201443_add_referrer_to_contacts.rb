class AddReferrerToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :referrer_id, :integer
  end
end
