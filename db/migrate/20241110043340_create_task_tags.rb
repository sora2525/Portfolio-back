class CreateTaskTags < ActiveRecord::Migration[7.1]
  def change
    create_table :task_tags do |t|
      t.references :tag, foreign_key: true, null: false
      t.references :task, foreign_key: true, null: false
      t.timestamps
    end
  end
end
