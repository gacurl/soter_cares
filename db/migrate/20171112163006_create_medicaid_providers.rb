class CreateMedicaidProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :medicaid_providers do |t|
      t.string :name

      t.timestamps
    end
  end
end
