class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :decision_id
      t.integer :root_child

      t.timestamps
    end
  end
end
