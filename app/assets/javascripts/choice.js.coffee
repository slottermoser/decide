# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Decision
  constructor:(info) ->
    @info = info
    @decision_id = @info.id
    @title = @info.title
    @me = @info.me
    @choices = []
    @choices.push(new Choice(choice_info)) for choice_info in @info.choices
    @my_votes = info.my_votes
    @votes = info.votes
    @voter_count = info.voter_count
    @my_id = info.my_id
    @participants = info.participants

  graph:() ->
    voteButtons = $(".vote-button")

    $(".graph-choice").each (index, element) =>
      choice_id = $(element).data("choiceId")
      vb = $('.vote-button[data-choice-id="' + choice_id + '"]')
      if @my_votes[choice_id]
          $(vb).find("div").addClass("btn-danger").removeClass("btn-success")
          $(vb).find("i").addClass("icon-minus").removeClass("icon-plus")
      else
          $(vb).find("div").addClass("btn-success").removeClass("btn-danger")
          $(vb).find("i").addClass("icon-plus").removeClass("icon-minus")
      vote_count = @votes[choice_id]
      $(element).data("voteCount", vote_count)
      barWidth = 100 * parseFloat(vote_count / @voter_count)
      $(element).find(".graph-choice-bar").css("width", barWidth + "%")
      $(element).find(".graph-choice-votes").text(vote_count + " votes")

  build_graph:() ->
    booth = $("#voting-booth")
    booth.html("")
    vButtons = @build_vote_buttons()
    booth.append(@build_vote_buttons())
    booth.append(@build_graph_area())
    $(".vote-button").each (index) ->
      $(this).bind 'click', () ->
        decision.vote(this)

  build_vote_buttons:() ->
    container = $('<div class="vote-buttons">')
    container.append($('<div class="graph-top-diff">'))
    container.append(choice.build_button()) for choice in @choices
    return container

  build_graph_area:() ->
    container = $('<div id="votes-graph-area" class="span5">')
    container.append($('<div class="graph-top">'))
    container.append(choice.build_bar()) for choice in @choices
    container.append($('<div class="graph-bottom">'))
    return container

  vote:(button) ->
    choiceId= $(button).data("choiceId")
    if $(button).find("div").hasClass("btn-success")
      @my_votes[choiceId] = true
      @votes[choiceId]++
      $.post '/choices/' + choiceId + '/vote.json', (data) =>
        if data.status is 'success'
          @checkIfNewParticipant()
          vote_info = {}
          vote_info["voter_id"] = @my_id
          vote_info["choice_id"] = choiceId
          vote_info["vote"] = 1
          socket.emit('vote change', vote_info)
        else
          alert("Sorry, there was an error casting your vote. Please refresh and try again")
          console.error(data.message)
    else
      @my_votes[choiceId] = false
      @votes[choiceId]--
      $.post '/choices/' + choiceId + '/delete_vote.json', (data) =>
        if data.status is 'success'
          @checkIfNewParticipant()
          vote_info = {}
          vote_info["voter_id"] = @my_id
          vote_info["choice_id"] = choiceId
          vote_info["vote"] = -1
          socket.emit('vote change', vote_info)
        else
          alert("Sorry, there was an error casting your vote. Please refresh and try again")
          console.error(data.message)
    @graph()

  voteChange:(vote_info) ->
    if vote_info.voter_id is @my_id
      if vote_info.vote == 1
        @my_votes[vote_info.choice_id] = true
      else
        @my_votes[vote_info.choice_id] = false
    @votes[vote_info.choice_id] += vote_info.vote
    @graph()

  checkIfNewParticipant:() ->
    if ($.inArray(@my_id, @participants) < 0)
      @participants.push(@my_id)
      new_p_info = {}
      new_p_info["id"] = @my_id
      new_p_info["name"] = @me.name
      new_p_info["email"] = @me.email
      socket.emit('new participant', new_p_info)
      @newParticipant(new_p_info)

  newParticipant:(p_info) ->
    @participants.push(p_info.id)
    newParticipant = $('<div class="item">')
    strong = $('<strong>')
    strong.text(p_info.name + ":")
    newParticipant.append(strong)
    newParticipant.append(" " + p_info.email)
    $("#participant-list").append(newParticipant)
    $("#participant-count").text(1 + parseInt($("#participant-count").text()))
    @voter_count++
    @graph()

  addChoice:(choice_info) ->
    choice = new Choice(choice_info)
    @choices.push(choice)
    @votes[choice.c_id] = choice.vote_count
    @build_graph()
    @graph()

class Choice
  constructor:(info) ->
    @c_id = info.id
    @title = info.title
    @creator = info.creator
    @vote_count = info.vote_count

  build_button:() ->
    vButton = $('<div class="vote-button" data-choice-id="' + @c_id + '">')
    btnContainer = $('<div class="btn">')
    btnContainer.append($('<i class="icon-white">'))
    vButton.append(btnContainer)
    return vButton

  build_bar:() ->
    container = $('<div class="graph-choice" data-choice-id="' + @c_id + '" data-vote-count="' + @vote_count + '">')
    container.append($('<div class="graph-choice-bar">'))
    textContainer = $('<div class="graph-choice-text">')
    title = $('<div class="graph-choice-title">')
    title.text(@title)
    textContainer.append(title) 
    textContainer.append('<div class="graph-choice-votes">')
    container.append(textContainer)
    return container

class ChoiceForm
  constructor:(decision_id) ->
    @decision_id = decision_id

  build_form:() ->
    container = $('<form action="/" id="new-choice-form" onsubmit="return false;" class="form-inline">')
    container.append($('<input id="new-choice-desc" type="text" name="choice[title]" class="input" placeholder="Description">'))
    container.append($('<input type="hidden" name="choice[decision_id]" value="' + @decision_id + '">'))
    container.append($('<button id="new-choice-submit" type="submit" class="btn btn-success">Add</button>'))
    $("#add-choice-form-container").html(container)
    $("#new-choice-desc").focus()
    decision_id = @decision_id
    $("#new-choice-form").submit () ->
      @choice_info = $("#new-choice-form").serialize()
      $.post "/choice/create", @choice_info, (data) ->
        decision.addChoice(data) #dangerously assuming this is defined...
        $("#add-choice-form-container").html("New Choice Added: " + data.title)
        socket.emit('new choice', data)

window.Decision = Decision
window.Choice = Choice
window.ChoiceForm = ChoiceForm
