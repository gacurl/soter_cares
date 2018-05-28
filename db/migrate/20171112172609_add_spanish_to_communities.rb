class AddSpanishToCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :communities, :spanish, :boolean, default: false
    add_column :contacts, :spanish, :boolean, default: false
  end
end
