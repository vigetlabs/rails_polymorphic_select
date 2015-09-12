class CreateAnimals < ActiveRecord::Migration
  def change
    create_table :animals do |t|
      t.string :name, null: false
      t.string :scientific_name, null: false

      t.references :eats, polymorphic: true

      t.timestamps null: false
    end
  end
end
