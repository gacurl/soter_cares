class AddPhonesToCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :communities, :phone_number, :string
    add_column :communities, :fax, :string
    add_column :communities, :al_license, :string
  end
end
