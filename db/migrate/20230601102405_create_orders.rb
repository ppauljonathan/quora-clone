class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :credit_pack, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.string :number, null: false, unique: true
      t.integer :amount

      t.timestamps
    end
  end
end
