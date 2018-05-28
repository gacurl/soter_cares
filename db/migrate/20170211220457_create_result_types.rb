class CreateResultTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :result_types do |t|
      t.string :name
    end
    
    remove_column :results, :result_type
    add_reference :results, :result_type
    add_column    :results, :created_at, :datetime
  end
end
