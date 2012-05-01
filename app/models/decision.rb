class Decision < ActiveRecord::Base
  has_one :discussion
  has_and_belongs_to_many :participants, :class_name => "User", :join_table => "decisions_participants"
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
  has_many :choices
  has_one :deadline_check

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

  def top_choices
    return nil if self.choices.nil?
    top = []
    self.choices.each do |c|
      if top.empty?
        top << c
      elsif c.vote_count == top[0].vote_count
        top << c
      elsif c.vote_count > top[0].vote_count
        top = [c]
      end
    end
    return top
  end

  def participant_ids
    ids = []
    self.participants.each do |p|
      ids << p.id
    end
    return ids
  end

  def as_json(options)
    if options[:user_id]
      votes, user_votes = self.votes(options[:user_id])
      cu = User.find(options[:user_id])
    end
  	base_json = super(:only => [:id, :title, :updated_at, :user_id])
  	base_json[:choices] = self.choices_as_json
    base_json[:votes] = votes
    base_json[:my_votes] = user_votes
    base_json[:voter_count] = self.participants.count
    base_json[:my_id] = options[:user_id]
    base_json[:me] = {:user_id => cu.id, :name => cu.name, :email => cu.email}
    base_json[:participants] = self.participant_ids
  	return base_json
  end
end
