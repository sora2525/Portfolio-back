class RemoveDateFormDiaries < ActiveRecord::Migration[7.1]
  def change
    remove_column :diaries, :date, :date
  end
end
