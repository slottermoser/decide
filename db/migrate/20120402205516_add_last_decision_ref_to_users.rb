class AddLastDecisionRefToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_decision_ref, :int

  end
end
