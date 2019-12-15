class CreateCoupenes < ActiveRecord::Migration[5.2]
  def change
    create_table :coupenes do |t|
      t.integer :user_id, add_index: :true
      t.float :amount
      t.string :reference

      t.timestamps
    end
  end
end
