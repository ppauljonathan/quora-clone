class CreateCreditPacks < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_packs do |t|
      t.decimal :price, precision: 7, scale: 2
      t.integer :credit_amount
      t.text :description

      t.timestamps
    end
  end
end
