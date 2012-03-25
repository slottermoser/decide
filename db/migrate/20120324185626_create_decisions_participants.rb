class CreateDecisionsParticipants < ActiveRecord::Migration
  def change
    create_table :decisions_participants, :id => false do |t|
      t.integer :decision_id
      t.integer :user_id
    end
  end
end
