class AddWebsiteToCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :communities, :website, :string
    add_column :communities, :admissions_director_id, :integer
    add_column :communities, :average_age, :float
    add_monetize :finances, :medicaid
    add_monetize :communities, :pet_fee
  end
end
