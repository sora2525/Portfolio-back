class CreateDiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :diaries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false                  
      t.string :title                            
      t.text :content, null: false              
      t.boolean :is_public, default: false      
      t.text :character_comment    
      
      t.timestamps
    end
  end
end
