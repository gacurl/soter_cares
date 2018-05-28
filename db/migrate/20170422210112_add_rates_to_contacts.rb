class AddRatesToContacts < ActiveRecord::Migration[5.0]
  def change
    add_monetize :results, :rate
    add_monetize :results, :deferred_rate
  end
end
