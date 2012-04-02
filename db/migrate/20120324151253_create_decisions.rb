class CreateDecisions < ActiveRecord::Migration
  def change
    create_table :decisions do |t|
      t.string :title
      t.integer :user_id

      t.timestamps
    end
  end
end
