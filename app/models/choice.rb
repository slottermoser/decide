class Choice < ActiveRecord::Base
  belongs_to :decision
  belongs_to :creator, :class_name => "User", :foreign_key => "creator"
  has_many :votes

  before_save :ensure_creator
  before_save :set_default_vote_count

  def voted_by_me(my_id)
    vote = Vote.find_by_voter_and_choice_id(my_id, self.id)
    if vote.nil?
      return false
    else
      return true
    end
  end

  private

    def ensure_creator
      if self.creator.nil?
        self.creator = self.decision.creator
      end
    end

    def set_default_vote_count
      if self.vote_count.nil?
        self.vote_count = 0
      end
    end
end
