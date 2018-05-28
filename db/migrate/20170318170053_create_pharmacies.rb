class CreatePharmacies < ActiveRecord::Migration[5.0]
  def change
    rename_column :pharmacies, :company_id, :community_id
    add_column :pharmacies, :email, :string
  end
end
