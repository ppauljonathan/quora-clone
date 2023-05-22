class AddPublishedAtToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :published_at, :timestamp
  end
end
