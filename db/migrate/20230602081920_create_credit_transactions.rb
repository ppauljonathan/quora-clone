class CreateCreditTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_transactions do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :stripe_session_id
      t.integer :status

      t.timestamps
    end
  end
end
