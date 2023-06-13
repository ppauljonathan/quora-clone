class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :abuse_reports do |t|
      t.references :reportable, polymorphic: true, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
