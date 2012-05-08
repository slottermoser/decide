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
    }).append("Reply")
    @entry_container = $('<div class="entry" id="entry'+@id+'">').append(
      $('<span class="content">').append(@response)
    ).append(
      $('<div class="info">').append(
        $('<span class="user">').append("-" + @name)
      ).append(
        $('<span class="created">').append(@created)
      )
    ).append(@reply_button)
    @discussion.comment(@reply_button,@container,true,@id)
    return @entry_container

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

  add_new_comment:(comment_text,well) ->
    if comment_text == '' 
      return
    that = this
    $.post(
      '/discussion/new_comment/' + @id,
      {text: comment_text},
      (data) ->
        if data.status == 'success'
          well.remove()
          that.add_new_entry(data.entry_info)
          socket.emit('new comment', {entry_info: data.entry_info})
        else
          console.error(data.message)
    )

  add_reply:(id,reply_text,well) ->
    that = this
    entry = Entry.reg[id]
    $.post(
      '/discussion/add_reply/' + id, {
        text: reply_text
      },
      (data) ->
        if data.status == 'success'
          well.remove()
          entry.children.push(new Entry data.entry_info, that,)
          socket.emit('new reply', {entry_info: data.entry_info})
          that.refresh()
        else
          console.error(data.message)
    )

  comment:(btn,parent,reply = false,reply_id = null) ->
    that = this
    btn.click (evt) ->
      evt.stopPropagation()
      if $('.comment_input_container')[0]
        $('.comment_input_container').fadeOut 'fast', ->
      well = $('<div class="well comment_input_container">')
      placeholder = "Leave a comment..."
      if reply
        well.addClass('children')
        placeholder = "Write a reply..."
      well.hide()
      comment_input = $('<textarea class="comment_input" placeholder="'+placeholder+'">')
      well.append(comment_input)
      comment_btn = $('<button class="btn">Save</button>')
      comment_btn.click (e) ->
        comment_btn.attr('disabled','true')
        text = comment_input.val()
        if reply
          that.add_reply(reply_id,text,well)
        else
          that.add_new_comment(text,well)
      well.append(comment_btn)
      parent.append(well)
      well.click (e) ->
        e.stopPropagation()
      $(document).click (e) ->
        well.fadeOut 'slow', ->
          well.remove()
      well.fadeIn 'fast', ->

window.Discussion = Discussion

###
class Comment
  constructor: (btn, parent) ->
    @btn = btn
    @parent = parent

  comment:(btn,parent,reply = false) ->
    btn.click (evt) ->
      evt.stopPropagation()
      if $('.comment_input_container')[0] 
        $('.comment_input_container').fadeOut 'fast', ->
      well = $('<div class="well comment_input_container">')
      if reply
        well.addClass('children'); 
      well.hide()
      comment_input = $('<textarea class="comment_input">')
      well.append(comment_input)
      comment_btn = $('<button class="btn">Save</button>')
      well.append(comment_btn)
      parent.append(well)
      well.click (e) ->
        e.stopPropagation()
      $(document).click (e) ->
        well.fadeOut 'slow', ->
          well.remove()
      well.fadeIn 'fast', ->


window.Comment = Comment
###
