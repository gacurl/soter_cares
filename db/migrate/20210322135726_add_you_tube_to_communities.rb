class AddYouTubeToCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :communities, :youtube_identifier, :string
  end
end
