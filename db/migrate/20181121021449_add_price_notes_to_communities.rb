class AddPriceNotesToCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :communities, :price_notes, :text
  end
end
