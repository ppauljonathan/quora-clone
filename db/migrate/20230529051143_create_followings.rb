class CreateFollowings < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :followers, table_name: :followings do |t|
      t.index %i[user_id follower_id], unique: true, name: 'unique_followers'
    end
  end
end
