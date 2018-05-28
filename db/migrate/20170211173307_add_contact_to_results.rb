class AddContactToResults < ActiveRecord::Migration[5.0]
  def change
    add_reference :results, :contact, foreign_key: true
  end
end
