class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.belongs_to :user, null: true, foreign_key: true
      t.belongs_to :question, null: false, foreign_key: true
      t.timestamp :published_at, default: nil

      t.timestamps
    end
  end
end
