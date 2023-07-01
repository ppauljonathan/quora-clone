class ChangeTableOrders < ActiveRecord::Migration[7.0]
  def change
    change_table :orders do |t|
      t.remove_belongs_to :credit_pack, foreign_key: true
    end
  end
end
