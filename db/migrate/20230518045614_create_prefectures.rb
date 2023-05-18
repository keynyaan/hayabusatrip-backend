class CreatePrefectures < ActiveRecord::Migration[7.0]
  def change
    create_table :prefectures do |t|
      t.string :name, null: false
      t.string :image_path, null: false
      t.timestamps
    end
  end
end
