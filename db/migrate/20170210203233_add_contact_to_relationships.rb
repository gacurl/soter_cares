class AddContactToRelationships < ActiveRecord::Migration[5.0]
  def change
    add_reference :relationships, :contact, foreign_key: true
  end
end
