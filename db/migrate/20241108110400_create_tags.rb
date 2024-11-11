class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name
      t.string :color
      t.timestamps
    end
  end
end
