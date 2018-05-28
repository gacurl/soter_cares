class CommunityMoney < ActiveRecord::Migration[5.0]
  def change
    remove_column :communities, :semi_private_cents
    remove_column :communities, :private_cents
    remove_column :communities, :community_fee_cents
    remove_column :communities, :respite_rate_cents
    remove_column :communities, :adult_day_care_rate
    add_monetize  :communities, :semi_private
    add_monetize  :communities, :private
    add_monetize  :communities, :community_fee
    add_monetize  :communities, :respite_rate
    add_monetize  :communities, :adult_day_care_rate
  end
end
