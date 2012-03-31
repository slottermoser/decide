# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Entry
  constructor: (entry_info, discussion) ->
    @children = (new Entry child, discussion for child in entry_info.children)
    entry = entry_info.entry
    @response = entry.entry
    @created = entry.created_at
    @id = entry.id
    @name = entry.name
    @discussion = discussion
    Entry.reg[@id] = this
    
  build:() ->
    @container = $('<div>')
    @container.append(@build_entry_container())
    @container.append(@build_children_container())
    return @container
  
  build_children_container:() ->
    @children_container = $("<div class='children'>")
    @children_container.append(entry.build()) for entry in @children
    return @children_container
  
  build_entry_container:() ->
    that = this
    @reply_button = $("<button>").attr({
      'class':'btn reply-button',
    }).append("Reply").bind('click', (event) ->
      that.reply_dialog(event)
    )
    @entry_container = $("<div class='entry'>").append(
      $('<span class="content">').append(@response)
    ).append(
      $('<div class="info">').append(
        $('<span class="user">').append("-" + @name)
      ).append(
        $('<span class="created">').append(@created)
      )
    ).append(@reply_button)
    return @entry_container
    
  reply_dialog:(event) ->
    that = this
    reply_input = $('<textarea>')
    content = $('<div>').attr({'class':'new_reply'}).append(
        $('<label>').attr({'for':'reply_value'}).append('Reply:')
      ).append(reply_input)
    new ModalWindow(
      okButtonText:'Save Reply'
      okCallback:() ->
        that.add_reply(event, reply_input.val())
      cancelButtonText:'Cancel'
      title:"Reply"
    ).set_content(content).show()
    
  add_reply:(event, reply_text) ->
    that = this
    $.post(
      '/discussion/add_reply/' + @id, { 
        text: reply_text
      },
      (data) ->
        if data.status == 'success'
          that.children.push(new Entry data.entry_info, that.discussion,)
          socket.emit('new reply', {entry_info: data.entry_info})
          that.discussion.refresh()
        else
          console.error(data.message)
    )
  
  add_child:(entry_info) ->
    @children.push(new Entry entry_info, @discussion)
    @discussion.refresh()
    
window.Entry = Entry
window.Entry.reg = {}
 
class Discussion
  constructor: (top_level_entries, options) ->
    @id = options.id
    @top_level = (new Entry entry, this for entry in top_level_entries)
  
  build:() ->
    @container = $("<div class='top_level'>")
    for entry in @top_level
      @container.append(entry.build())
    return @container
  
  add_new_entry:(entry_info) ->
    @top_level.push(new Entry entry_info, this)
    @refresh()
  
  refresh:() ->
    @container[0].innerHTML = ""
    for entry in @top_level
      @container.append(entry.build())

window.Discussion = Discussion
