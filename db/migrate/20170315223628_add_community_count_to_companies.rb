class AddCommunityCountToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :communities_count, :integer, default: 0, null: false
  end
end
