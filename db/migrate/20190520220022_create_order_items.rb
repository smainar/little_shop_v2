class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.references :item, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :quantity
      t.decimal :price_per_item
      t.boolean :fulfilled, default: false

      t.timestamps
    end
  end
end
