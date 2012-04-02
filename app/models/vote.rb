class Vote < ActiveRecord::Base
  belongs_to :choice
  belongs_to :voter, :class_name => "User", :foreign_key => "voter"

  def as_json(options)
  	base_json = super(:only => [:id, :choice_id, :created_at])
  	base_json[:voter_id] = self.voter.id
  	return base_json
  end
end
