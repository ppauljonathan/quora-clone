class RemoveNullConstraintOnUserReferencesForQuestions < ActiveRecord::Migration[7.0]
  def change
    change_column_null :questions, :user_id, true
  end
end
