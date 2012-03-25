class DiscussionEntry < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :user
  has_many :children, :class_name => "DiscussionEntry",
    :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "DiscussionEntry",
    :foreign_key => "parent_id"
end
