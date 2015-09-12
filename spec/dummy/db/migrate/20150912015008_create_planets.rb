class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      t.string :name, null: false
      t.references :stars, null: false
      t.timestamps null: false
    end
  end
end
