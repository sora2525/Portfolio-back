class AddCompletionMessageToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :completion_message, :text
  end
end
