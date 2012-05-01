class CreateDeadlineChecks < ActiveRecord::Migration
  def change
    create_table :deadline_checks do |t|
      t.datetime :deadline
      t.integer :decision_id

      t.timestamps
    end
  end
end
