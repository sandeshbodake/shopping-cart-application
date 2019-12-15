class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.integer :user_id, add_index: :true
      t.integer :product_id, add_index: :true
      t.integer :quantity, default: 1
      t.float :amount

      t.timestamps
    end
  end
end
