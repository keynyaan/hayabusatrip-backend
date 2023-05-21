class AddIndexToTrips < ActiveRecord::Migration[7.0]
  def change
    add_index :trips, :trip_token, unique: true
  end
end
