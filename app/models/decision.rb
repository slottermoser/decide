class Decision < ActiveRecord::Base
  has_one :discussion
  has_and_belongs_to_many :participants, :class_name => "User", :join_table => "decisions_participants"
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
  has_many :choices

  def choices_as_json
  	choices = []
  	self.choices.each do |choice|
  	  choice_info = {
  	  	id:choice.id,
  	  	title:choice.title,
  	  	creator: {
  	  		id:choice.creator.id,
  	  		name:choice.creator.name,
  	  		email:choice.creator.email
  	  	},
  	  	decision_id:choice.decision_id,
  	  	vote_count:choice.vote_count,
  	  	updated_at:choice.updated_at
  	  }
  	  choices << choice_info
  	end
  	return choices
  end

  def as_json(options)
  	base_json = super(:only => [:id, :title, :updated_at, :user_id])
  	base_json[:choices] = self.choices_as_json
  	return base_json
  end
end
