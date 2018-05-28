class CreateProspectiveCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :prospective_communities do |t|
      t.references :contact, foreign_key: true
      t.references :community, foreign_key: true
    end
  end
end
