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

  def votes(user_id)
    votes = {}
    user_votes = {}
    i = 0
    self.choices.each do |choice|
      votes[choice.id] = choice.vote_count
      if choice.voted_by_me(user_id)
        user_votes[choice.id] = true
      else
        user_votes[choice.id] = false
      end
      i += 1
    end
    return votes, user_votes
  end

  def as_json(options)
    votes, user_votes = self.votes(options[:user_id])
  	base_json = super(:only => [:id, :title, :updated_at, :user_id])
  	base_json[:choices] = self.choices_as_json
    base_json[:votes] = votes
    base_json[:my_votes] = user_votes
    base_json[:voter_count] = self.participants.count + 1 #add 1 for creator
    base_json[:my_id] = options[:user_id]
  	return base_json
  end
end
