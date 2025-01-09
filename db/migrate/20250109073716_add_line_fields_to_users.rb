class AddLineFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :line_user_id, :string
    add_column :users, :line_sub, :string

    add_index :users, :line_sub, unique: true
    add_index :users, :line_user_id, unique: true
  end
end
