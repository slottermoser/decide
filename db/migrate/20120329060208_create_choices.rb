class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string :title
      t.integer :creator, presence: true
      t.integer :decision_id, presence: true
      t.integer :vote_count

      t.timestamps
    end
  end
end
