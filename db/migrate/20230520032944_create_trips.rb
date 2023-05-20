class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.references :user, null: false, foreign_key: true
      t.references :prefecture, null: false, foreign_key: true
      t.string :title, null: false, limit: 30
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :memo, limit: 1000
      t.string :image_path, null: false
      t.boolean :is_public, null: false, default: false
      t.string :trip_token, null: false

      t.timestamps
    end
  end
end
