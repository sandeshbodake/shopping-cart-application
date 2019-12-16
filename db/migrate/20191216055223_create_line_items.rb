class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.references :itemable, polymorphic: true
      t.float :amount
      t.integer :quantity

      t.timestamps
    end
  end
end
