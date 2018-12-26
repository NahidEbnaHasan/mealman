class CreateMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :meals do |t|
      t.integer :user_id
      t.integer :group_id
      t.date :date
      t.boolean :breakfast_done, default: false
      t.boolean :lunch_done, default: false
      t.boolean :dinner_done, default: false
      t.column :num_breakfast_taken, :decimal, precision: 10, scale: 2
      t.column :num_lunch_taken, :decimal, precision: 10, scale: 2
      t.column :num_dinner_taken, :decimal, precision: 10, scale: 2
      t.timestamps
    end
    add_index :meals, :user_id, unique: true
    add_index :meals, :group_id, unique: true
  end
end
