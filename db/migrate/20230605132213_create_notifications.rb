class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.index %i[question_id user_id], unique: true

      t.timestamps
    end
  end
end
