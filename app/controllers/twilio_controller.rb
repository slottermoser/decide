class TwilioController < ApplicationController
  def event
    @user = User.find_by_phone_number(params["From"].to_i)
    body = params["Body"].downcase
    parameters = body.split(" ")
    self.send(parameters[0], parameters[1...(parameters.length)])
  end

  def decisions(*args)
    decisions = @user.participating_decisions
    message = "Decisions:\n"
    decisions.each do |decision|
      message += "ID:" + decision.id.to_s + "\n"
    end
    self.send_message(@user.phone_number, message)
    render :nothing => true
  end
  
  def decision(*args)
    data = args[0]
    id = data[0]
    command = data[1].downcase
    decision = Decision.find(id)
    case command
    when "title"
      self.send_message(@user.phone_number, decision.title)
    when "choices"
      
    end
    render :nothing => true
  end

  def options(*args)
  end

  def vote(*args)
  end
  
  def send_message(phone_number, message)
    number_to_send_to = phone_number

    twilio_sid = "AC00aa58ab5d0b43b5aa10b98a5c1e189e"
    twilio_token = "53d39f2fda75d07892697eb060a23d50"
    twilio_phone_number = "8014712685"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    puts phone_number
    puts message
    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => message
    )
  end
end
