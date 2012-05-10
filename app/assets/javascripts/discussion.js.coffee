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
    parent = @container
    @reply_setup(parent)
    return @container
 
  reply_setup:(parent) ->
    that = this
    reply_id = @id
    parent.click (evt) ->
      if $(this).find('.reply_input_container').length
        return
      if $('.reply_input_container')[0]
        $('.reply_input_container').fadeOut 'slow', ->
          $(this).remove()
      evt.stopPropagation()
      placeholder = "Write a reply..."
      well_class = "reply_input_container"
      btn_text = "Reply"
      comment = new Comment
      well = comment.build(well_class,placeholder,btn_text)
      well.hide()
      btn = well.find('button')
      btn.click (e) ->
        btn.attr('disabled','true')
        comment_text = well.find('textarea')
        if comment_text.val() == ''
          return
        that.add_reply(reply_id,comment_text.val(),well)
      parent.append(well)
      well.addClass("children")
      well.click (e) ->
        e.stopPropagation()
      $(document).click (e) ->
        well.fadeOut 'slow', ->
          well.remove()
      well.fadeIn 'fast', ->
      well.find('textarea').focus()
 
  add_reply:(id,reply_text,well) ->
    that = this
    discuss = @discussion
    $.post(
      '/discussion/add_reply/' + id, {
        text: reply_text
      },
      (data) ->
        if data.status == 'success'
          well.remove()
          that.children.push(new Entry data.entry_info, that,)
          socket.emit('new reply', {entry_info: data.entry_info})
          discuss.refresh()
        else
          console.error(data.message)
    )

  build_children_container:() ->
    @children_container = $("<div class='children'>")
    @children_container.append(entry.build()) for entry in @children
    return @children_container
  
  build_entry_container:() ->
    that = this
    @entry_container = $('<div class="entry" id="entry'+@id+'">').append(
      $('<span class="content">').append(@response)
    ).append(
      $('<div class="info">').append(
        $('<span class="user">').append("-" + @name)
      ).append(
        $('<span class="created">').append(@created)
      )
    ).append(@reply_button)
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
    @container.append(@build_comment_box())
    return @container
  
  add_new_entry:(entry_info) ->
    @top_level.push(new Entry entry_info, this)
    @refresh()
  
  refresh:() ->
    @container[0].innerHTML = ""
    for entry in @top_level
      @container.append(entry.build())
    @container.append(@build_comment_box())

  add_new_comment:(comment_text) ->
    if comment_text == '' 
      return
    that = this
    $.post(
      '/discussion/new_comment/' + @id,
      {text: comment_text.val()},
      (data) ->
        if data.status == 'success'
          comment_text.val('')
          that.add_new_entry(data.entry_info)
          socket.emit('new comment', {entry_info: data.entry_info})
          that.refresh()
        else
          console.error(data.message)
    )
 
  build_comment_box:() ->
    comment = new Comment
    that = this
    well = comment.build("comment_input_container","Leave a comment...","Comment")
    btn = well.find('button')
    btn.click (evt) ->
      btn.attr('disable','true')
      comment_text = well.find('textarea')
      if comment_text.val() == ''
        btn.attr('disable','false')
        return
      that.add_new_comment(comment_text)
    return well

window.Discussion = Discussion

class Comment
  build:(well_class, placeholder,btn_text) ->
    well = $('<div class="well '+well_class+'">')
    comment_input = $('<textarea class="comment_input" placeholder="'+placeholder+'">')
    well.append(comment_input)
    comment_btn = $('<button class="btn btn-primary">'+btn_text+'</button>')
    well.append(comment_btn)
    return well

window.Comment = Comment
