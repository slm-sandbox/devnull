context = null

drawPlay = (player, sq)->
  context.font = "normal 90px Verdana"
  context.fillStyle = "black"
  if player is 1
    console.log sq.x
    console.log sq.y
    context.fillText "X", sq.x*100, (sq.y+1)*100
  else
    context.fillText "O", sq.x*100, (sq.y+1)*100

$ ->
  socket = io.connect()

  canvas = document.getElementById('canvas')
  canvas.width = 301
  canvas.height = 301
  context = canvas.getContext '2d'

  context.strokeRect 0,0,300,300
  context.strokeRect 0,0,100,100
  context.strokeRect 100,100,100,100
  context.strokeRect 200,0,100,100
  context.strokeRect 0,200,100,100
  context.strokeRect 200,200,100,100

  drawPlay 1, {x:200, y:300}

  socket.on 'board', (data)->
    for a, y in data
      for v, x in a
        drawPlay v, x:x, y:y unless v == 0

  $('canvas').click (e)->
    x = e.pageX
    y = e.pageY
    boardX = Math.floor(3*x/300)
    boardY = Math.floor(3*y/300)
    console.log boardX, boardY
    socket.emit 'place', boardX, boardY


  socket.emit 'join', 1