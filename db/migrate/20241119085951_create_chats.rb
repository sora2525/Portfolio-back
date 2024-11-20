class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :messages_type,null:false
      t.text :message,null: false
      t.timestamps
    end
  end
end
