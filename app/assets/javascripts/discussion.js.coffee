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
      'class':'btn',
    }).append("Reply").bind('click', (event) ->
      that.reply_dialog(event)
    )
    @entry_container = $("<div class='entry'>").append(
      $('<span class="response">').append(@response)
    ).append(
      $('<span class="created">').append(@created)
    ).append(@reply_button)
    return @entry_container
    
  reply_dialog:(event) ->
    that = this
    reply_input = $('<input>').attr({'type':'text'})
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
          that.children.push(new Entry data.entry_info, that.discussion)
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

class ModalWindow
  constructor: (@options = {
    okButtonText:'Ok',
    okCallback:() ->,
    cancelButtonText:'Cancel'
    title:'Modal Title'
  }) ->
    @build()
    
  build:() ->
    @dialog = $('<div>').attr({"class":"modal"})
    that = this
    @save_button = $('<button>').attr({'class':'btn btn-primary'}).append(@options.okButtonText)
    @save_button.bind('click', (event) ->
      that.options.okCallback(event)
      that.dialog.modal('hide')
      that.dialog.remove()
    )
    @close_button = $('<button>').attr({'class':'btn btn-error'}).append(@options.cancelButtonText)
    @close_button.bind('click', (event) ->
      that.dialog.modal('hide')
      that.dialog.remove()
    )
    @body = $('<div>').attr({'class':'modal-body'})
    @reply_input = $('<input>').attr({'type':'text'})
    @dialog.append(
      $('<div>').attr({"class":"modal-header"}).append(
        $('<a>').attr({'class':'close', 'data-dismiss':'modal'}).append('x')
      ).append(
        $('<h3>').append(@options.title)
      )
    ).append(@body).append(
      $('<div>').attr({'class':'modal-footer'}).append(
        @close_button
      ).append(
        @save_button
      )
    )
    
  set_content:(content) ->
    @body.append(content)
    return this
  
  show:() ->
    @dialog.modal('show')
    
window.ModalWindow = ModalWindow
