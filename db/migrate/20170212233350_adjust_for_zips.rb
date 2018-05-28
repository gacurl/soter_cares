class AdjustForZips < ActiveRecord::Migration[5.0]
  def change
    remove_column :communities, :city
    remove_column :communities, :state
    remove_column :communities, :zip
    add_reference :communities, :zip_code, foreign_key: true
    
    remove_column :pharmacies, :city
    remove_column :pharmacies, :state
    remove_column :pharmacies, :zip
    add_reference :pharmacies, :zip_code, foreign_key: true
    
    remove_column :companies, :city
    remove_column :companies, :state
    remove_column :companies, :zip
    add_reference :companies, :zip_code, foreign_key: true
    
    remove_column :contacts, :city
    remove_column :contacts, :state
    remove_column :contacts, :zip
    add_reference :contacts, :zip_code, foreign_key: true
  end
end
