socket = io.connect 'http://localhost:3000'
player = null;

join = ->
  socket.emit 'join'
  show()

$(document).on 'keydown', (e) -> function (e)

  if (e.which == 37) //left
    player = 'left'; 
    join()

  if (e.which == 38) //up
    socket.emit player, -10   

  if (e.which == 39) //right
    player = 'right'
    join()

  if (e.which == 40) //down
    socket.emit player, 10   

