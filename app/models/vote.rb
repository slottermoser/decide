class Vote < ActiveRecord::Base
  belongs_to :choice
  belongs_to :voter, :class_name => "User", :foreign_key => "voter"
end
