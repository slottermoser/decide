class CreateDiscussionEntries < ActiveRecord::Migration
  def change
    create_table :discussion_entries do |t|
      t.integer :discussion_id
      t.integer :user_id
      t.text :entry
      t.integer :parent_id

      t.timestamps
    end
  end
end
