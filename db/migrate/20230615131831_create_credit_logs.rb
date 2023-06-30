class CreateCreditLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :remark
      t.integer :credit_amount

      t.timestamps
    end
  end
end
