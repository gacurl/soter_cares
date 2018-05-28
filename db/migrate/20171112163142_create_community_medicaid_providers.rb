class CreateCommunityMedicaidProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :community_medicaid_providers do |t|
      t.references :medicaid_provider, foreign_key: true
      t.references :community
      t.timestamps
    end
    add_reference :contacts, :medicaid_provider
  end
end
