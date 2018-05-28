class AddCommunityCountToPharmacies < ActiveRecord::Migration[5.0]
  def change
    add_column :pharmacies, :communities_count, :integer
  end
end
