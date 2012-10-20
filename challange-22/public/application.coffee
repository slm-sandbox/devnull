appendMessage = (msg)->
  msgNode = $('<div class="msg"></div>')
  msgNode.text(msg)
  $('#messageList').append(msg)

$ ->
  window.socket = socket
  socket = io.connect()
  socket.on 'msg', (msg)->
    appendMessage msg