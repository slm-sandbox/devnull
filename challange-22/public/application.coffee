name = null

appendMessage = (msg)->
  msgNode = $('<div class="msg"></div>')
  msgNode.text(msg)
  $('#messageList').append(msgNode)

login = ->
  $('#login').hide()
  $('#messages').show()

$ ->
  window.socket = socket
  socket = io.connect()
  socket.on 'msg', (msg)->
    appendMessage msg

  $('#join').click ->
    name = $('#name').val()
    socket.emit 'join', name
    login()

  $('#send').click ->
    msg = $('#msg').val()
    socket.emit 'send', msg