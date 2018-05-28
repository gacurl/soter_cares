class ChangeFacilityOnCOmmunities < ActiveRecord::Migration[5.0]
  def change
    remove_column :contacts, :county
    rename_column :contacts, :patient_community_id, :facility_id
  end
end
