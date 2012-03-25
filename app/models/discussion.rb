class Discussion < ActiveRecord::Base
  has_many :discussion_entry
  has_many :top_level_entries, :class_name => "DiscussionEntry",
    :conditions => {:parent_id => nil}
  belongs_to :decision
end
