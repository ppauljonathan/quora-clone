class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :title, unique: true
      t.text :content
      t.string :url_slug, unique: true
      t.references :user, null: false, foreign_key: true
      t.timestamp :published_at, default: nil

      t.timestamps
    end
  end
end
