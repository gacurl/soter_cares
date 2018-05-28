class AddSecondToCommunites < ActiveRecord::Migration[5.0]
  def change
    add_monetize :communities, :second_person_fee
  end
end
