class AddHierarchyToDecisionMakers < ActiveRecord::Migration[5.0]
  def change
    remove_column :decision_makers, :patient_id, :integer
    add_column    :decision_makers, :hierarchy, :integer
    add_index :decision_makers, [:contact_id, :relationship_id, :hierarchy], unique: true,
        name: "unique_decision_makers"
  end
end
