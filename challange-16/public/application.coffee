$ ->

  A = 31
  B = 16

  socket = io.connect()

  # canvas = document.createElement 'canvas'
  # canvas.height = A*B
  # canvas.width = A*B
  # window.ctx = canvas.getContext '2d'
  # ctx.scale B, B

  # document.body.appendChild canvas

  canvas = document.createElement 'img'
  canvas.height = A*B
  canvas.width = A*B

  document.body.appendChild canvas

  socket.on 'draw', (str)->
    canvas.src = str

  socket.on 'game-over', ->
    alert "You're dead"

  player =
    move: (dx, dy)->
      socket.emit 'move', dx, dy

  $(document).on 'keydown', (e) ->
  
    if (e.which == 32) #space
      socket.emit 'join'
  
    if (e.which == 37) #left
      player.move(-1, 0)     
  
    if (e.which == 38) #up
      player.move(0, -1)
  
    if (e.which == 39) #right
      player.move(1, 0)
  
    if (e.which == 40) #down
      player.move(0, 1)
  