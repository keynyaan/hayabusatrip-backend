class ModifyUsersTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :request_count, :integer
    remove_column :users, :last_reset_date, :date
    change_column :users, :name, :string, limit: 20
  end
end
