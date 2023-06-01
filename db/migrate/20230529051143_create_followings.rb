class CreateFollowings < ActiveRecord::Migration[7.0]
  def change
    create_join_table :followees, :followers, table_name: :followings do |t|
      t.index %i[followee_id follower_id], unique: true, name: 'unique_followers'
    end
  end
end
