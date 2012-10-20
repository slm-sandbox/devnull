appendMessage = (msg)->
  msgNode = $('<div class="msg"></div>')
  msgNode.text(msg)
  $('#messageList').append(msg)

$ ->
  socket = io.connect()
  socket.on 'msg', (msg)->
    appendMessage msg