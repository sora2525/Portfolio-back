class AddNotifiedToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :notified, :boolean, default: false, null: false
  end
end
