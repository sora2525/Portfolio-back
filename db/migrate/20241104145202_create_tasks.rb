class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false                      
      t.text :description                               
      t.date :due_date                                
      t.integer :priority, default: 0                  
      t.date :completion_date                      
      t.datetime :reminder_time                      

      t.timestamps
    end
  end
end
