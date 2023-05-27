class AddReportedAtToResource < ActiveRecord::Migration[7.0]
  def change
    %i[questions answers comments].each do |table|
      add_column table, :reported_at, :timestamp
    end
  end
end
