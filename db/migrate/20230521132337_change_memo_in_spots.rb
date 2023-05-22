class ChangeMemoInSpots < ActiveRecord::Migration[7.0]
  def change
    change_column :spots, :memo, :string, limit: 50, null: false, default: ""
  end
end
