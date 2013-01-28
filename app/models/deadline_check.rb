#include Rails.application.routes.url_helpers
require 'gmail'

class DeadlineCheck < ActiveRecord::Base
  belongs_to :decision

  def self.check
    gmail = nil
    deadlines = DeadlineCheck.order("deadline DESC")
    count = 0
    deadlines.each do |check|
      if check.decision.nil?
        check.destroy
        next
      end
      if check.deadline - DateTime.now <= 0
        if gmail.nil?
          gmail = Gmail.new(GMAIL_LOGIN, GMAIL_PASSWORD)
        end
        count += 1
        decision = check.decision
        subjectString = "Decision Made"
        subjectString << " - " << decision.title[0...50] unless decision.title.nil?
        subjectString << "..." if decision.title.length > 50 unless decision.title.nil?
        bodyString = self.bodyStringForDecision(decision)
        addresses = ""
        decision.participants.each do |p|
          addresses << p.email << ", "
        end
        email = gmail.deliver do
          to addresses
          from GMAIL_FROM
          subject subjectString
          html_part do
            body bodyString
          end
        end

        # Remove deadline check
        check.destroy
      else
        break #all passed deadlines handled
      end
    end
    unless gmail.nil?
      gmail.logout
    end
    return count
  end

  def self.bodyStringForDecision(decision)
    body = "A decision has been made. Check it out: https://decide.holdtotherod.net/decisions/"
    body << decision.id.to_s
    body << "\n\n"
    body << "Question: " << decision.title
    body << "\nAsked by: " << decision.creator.name
    top_choices = decision.top_choices
    if top_choices.nil?
      body << "\nNo choices were made :(" << "\n"
    elsif top_choices.size == 1
	  body << "\nTop Choice: " << top_choices[0].title << "\n"
    else
      body << "\nTop Choices:\n"
      top_choices.each do |c|
        body << "  " << c.title << "\n"
      end
    end
    body << "\n-The Decide Team"
  end
end
