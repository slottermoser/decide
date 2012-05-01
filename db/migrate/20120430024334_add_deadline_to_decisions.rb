class AddDeadlineToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :deadline, :datetime

  end
end
