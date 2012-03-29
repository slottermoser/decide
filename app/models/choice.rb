class Choice < ActiveRecord::Base
  belongs_to :decision
  belongs_to :creator, :class_name => "User", :foreign_key => "creator"

  before_save :ensure_creator

  private

    def ensure_creator
      if self.creator.nil?
        self.creator = self.decision.creator
      end
    end
end
