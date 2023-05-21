class ChangeMemoInTrips < ActiveRecord::Migration[7.0]
  def change
    change_column :trips, :memo, :string, limit: 1000, null: false, default: ""
  end
end
