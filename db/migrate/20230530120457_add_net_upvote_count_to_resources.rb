class AddNetUpvoteCountToResources < ActiveRecord::Migration[7.0]
  def change
    %i[answers comments].each do |table|
      add_column table, :net_upvote_count, :integer, default: 0
    end
  end
end
