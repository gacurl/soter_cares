class AddCommunityToResults < ActiveRecord::Migration[5.0]
  def change
    add_reference :results, :community, foreign_key: true
  end
end
