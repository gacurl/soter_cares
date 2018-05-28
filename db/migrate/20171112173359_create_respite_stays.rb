class CreateRespiteStays < ActiveRecord::Migration[5.0]
  def change
    create_table :respite_stays do |t|
      t.references :contact, foreign_key: true
      t.references :community, foreign_key: true
      t.datetime :start
      t.datetime :stop
      t.monetize :fee

      t.timestamps
    end
  end
end
