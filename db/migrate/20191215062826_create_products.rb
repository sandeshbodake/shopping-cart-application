class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :currency_id, add_index: :true
      t.string :description
      t.integer :category_id, add_index: :true

      t.timestamps
    end
  end
end
