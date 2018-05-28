class AddGenderToRelationshipTypes < ActiveRecord::Migration[5.0]
  def change
    add_column  :relationship_types, :male_name, :string
    add_column  :relationship_types, :male_opposite, :string
    add_column  :relationship_types, :female_name, :string
    add_column  :relationship_types, :female_opposite, :string
  end
end
