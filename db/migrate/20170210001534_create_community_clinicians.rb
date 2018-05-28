class CreateCommunityClinicians < ActiveRecord::Migration[5.0]
  def change
    remove_column :communities, :clinician_id 
    
    create_table :community_clinicians do |t|
      t.references :community
      t.references :clinician
    end
  end
end
