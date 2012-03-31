# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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