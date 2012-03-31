class AddIndexToVotesOnVoterAndChoice < ActiveRecord::Migration
  def change
    add_index :votes, [:voter, :choice_id], :unique => true
  end
end
