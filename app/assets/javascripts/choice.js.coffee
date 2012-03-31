# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Decision
  constructor:(info) ->
    @info = info
    @title = @info.title
    @creator = @info.creator
    @choices = []
    @choices.push(new Choice(choice_info)) for choice_info in @info.choices

  graph:() ->
    rows = @choice_rows()
    data = new google.visualization.DataTable()
    data.addColumn('string', 'Choices')
    data.addColumn('number', 'Votes')
    data.addRows(rows)
    options = {title:@title, hAxis:{minValue: 0}}
    @chart = new google.visualization.BarChart(document.getElementById('chart_div'));
    @chart.draw(data, options)

  choice_rows:() ->
    rows = []
    rows.push choice.row() for choice in @choices
    return rows

  build_choices:(choice_data) ->
  	choices = []
  	choices.push(new Choice(choice_info)) for choice_info in choice_data
  	return choices

class Choice
  constructor:(info) ->
    @title = info.title
    @creator = info.creator
    @vote_count = info.vote_count

  row:() ->
  	row = []
  	row.push @title
  	row.push @vote_count
  	return row

window.Decision = Decision
window.Choice = Choice
