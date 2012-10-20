$ ->

  socket = io.socket()

  player =
    move: (dx, dy)->
      socket.emit 'move', dx, dy

  $(document).on 'keydown', (e) ->
  
    if (e.which == 37) #left
      player.move(-1, 0)     
  
    if (e.which == 38) #up
      player.move(0, -1)
  
    if (e.which == 39) #right
      player.move(1, 0)
  
    if (e.which == 40) #down
      player.move(0, 1)
  