class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :name, null: false
      t.string :scientific_name, null: false

      t.timestamps null: false
    end
  end
end
