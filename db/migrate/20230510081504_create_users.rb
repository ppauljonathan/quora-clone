class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false,  unique: true
      t.string :password_digest, null: false
      t.integer :credits, default: 0
      t.boolean :is_admin, default: false
      t.timestamp :verified_at
      t.timestamp :disabled_at
      t.string :verification_token
      t.string :reset_token

      t.timestamps
    end
  end
end
