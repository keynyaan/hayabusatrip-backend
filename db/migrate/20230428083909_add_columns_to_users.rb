class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false, default: '新規ユーザー'
    add_column :users, :icon_path, :string, null: false, default: '/images/default-user-icon.png'
    add_column :users, :request_count, :integer, null: false, default: 0
    add_column :users, :last_reset_date, :date
    add_column :users, :last_login_time, :datetime
  end
end