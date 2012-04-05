class TwilioController < ApplicationController
  def event
    @user = User.find_by_phone_number(params["From"].to_i)
    body = params["Body"].downcase
    parameters = body.split(" ")
    self.send(parameters[0], parameters[1...(parameters.length)])
    render :nothing => true
  end

  def decisions(*args)
    decisions = @user.participating_decisions
    message = "Decisions:\n"
    decisions.each do |decision|
      message += "ID:" + decision.id.to_s + "\n"
    end
    self.send_message(@user.phone_number, message)
  end
  
  def decision(*args)
    data = args[0]
    id = data[0]
    decision = Decision.find(id)
    @user.last_ref_decision = decision
  end
  
  def title(*args)
    decision = @user.last_ref_decision
    self.send_message(@user.phone_number, decision.title)
  end
  
  def choices(*args)
    decision = @user.last_ref_decision
    message = "Choices: "
    choices = decision.choices
    choices.each do |choice|
      message += " | Title:" + choice.title + ", ID:" + choice.id.to_s
    end
    self.send_message(@user.phone_number, message)
  end

  def vote(*args)
    data = args[0]
    id = data[0]
    choice = Choice.find(id)
    @user.votes.each do |vote|
      if vote.choice == choice
        self.send_message(@user.phone_number, "You have already voted for that choice")
        return
      end
    end
    vote = Vote.new
    vote.voter = @user
    vote.choice = choice
    if vote.save
      choice.vote_count += 1
      choice.save
      self.send_message(@user.phone_number, "You have voted successfully")
    else
      self.send_message(@user.phone_number, "You're vote was not successful")
    end
  end
  
  def comment(*args)
    data = args[0]
    text = data.join(" ")
    new_comment = DiscussionEntry.new({:entry => text})
    new_comment.discussion = @user.last_ref_decision.discussion
    new_comment.user = @user
    if new_comment.save
      self.send_message(@user.phone_number, "You have commented successfully")
    else
      self.send_message(@user.phone_number, "You're comment was not successful")
    end
  end
  
  def send_message(phone_number, message)
    number_to_send_to = phone_number

    twilio_sid = "AC00aa58ab5d0b43b5aa10b98a5c1e189e"
    twilio_token = "53d39f2fda75d07892697eb060a23d50"
    twilio_phone_number = "8014712685"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => message
    )
  end
end
