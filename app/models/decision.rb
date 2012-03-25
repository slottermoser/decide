class Decision < ActiveRecord::Base
  has_one :discussion
  has_and_belongs_to_many :participants, :class_name => "User", :join_table => "decisions_participants"
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
end
