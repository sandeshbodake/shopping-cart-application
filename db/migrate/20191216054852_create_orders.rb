class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :product_id, add_index: true
      t.integer :user_id, add_index: true
      t.float :amount
      t.integer :counpne_id, add_index: true

      t.timestamps
    end
  end
end
