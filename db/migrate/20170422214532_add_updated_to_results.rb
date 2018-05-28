class AddUpdatedToResults < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :updated_at, :datetime
  end
end
