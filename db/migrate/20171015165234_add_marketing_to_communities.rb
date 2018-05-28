class AddMarketingToCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :communities, :marketing_director_id, :integer
  end
end
