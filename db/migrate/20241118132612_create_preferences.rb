class CreatePreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :affnity_level, default: 0    
      t.timestamps
    end
  end
end
