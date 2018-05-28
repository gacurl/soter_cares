class ChangeCommunityToCOmpanyOnInvoices < ActiveRecord::Migration[5.0]
  def change
    rename_column :invoices, :community_id, :company_id
    rename_column :availabilities, :communities_id, :community_id
  end
end
