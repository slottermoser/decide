class Discussion < ActiveRecord::Base
  has_many :discussion_entry
  has_many :top_level_entries, :class_name => "DiscussionEntry",
    :conditions => {:parent_id => nil}
  belongs_to :decision

  def entries_as_json
  	build_entries_json(self.top_level_entries)
  end

  def build_entries_json(entries)
    results = []
    entries.each do |entry|
      children = build_entries_json(entry.children)
      entry_info = {
        name:entry.user.name,
        created_at:entry.created_at.strftime('%m/%d/%Y %H:%M'),
        entry:entry.entry,
        id:entry.id
      }
      results << {
        :entry => entry_info,
        :children => children
      }
    end
    return results
  end

  def as_json(options)
  	base_json = super(:only => [:decision_id,:rood_child,:updated_at])
  	base_json[:entries] = self.entries_as_json
  	return base_json
  end
end
