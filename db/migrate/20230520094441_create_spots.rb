class CreateSpots < ActiveRecord::Migration[7.0]
  def change
    create_table :spots do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :spot_icon, null: false, default: "location-dot"
      t.string :title, null: false, limit: 30
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :cost, null: false, default: 0
      t.string :memo

      t.timestamps
    end
  end
end
