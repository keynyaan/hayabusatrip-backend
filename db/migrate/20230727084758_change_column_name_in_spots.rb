class ChangeColumnNameInSpots < ActiveRecord::Migration[7.0]
  def change
    rename_column :spots, :spot_icon, :category
    rename_column :spots, :title, :name
    change_column_default :spots, :category, from: 'location-dot', to: 'sightseeing'
  end
end
