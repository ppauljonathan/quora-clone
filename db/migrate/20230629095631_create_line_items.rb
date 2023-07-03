class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :credit_pack, null: false, foreign_key: true
      t.decimal :amount, precision: 9, scale: 2
      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
