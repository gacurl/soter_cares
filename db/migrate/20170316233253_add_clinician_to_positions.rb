class AddClinicianToPositions < ActiveRecord::Migration[5.0]
  def change
    add_column :positions, :clinician, :boolean
  end
end
