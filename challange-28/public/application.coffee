context = null

drawPlay = (player, sq)->
  context.font = "normal 90px Verdana"
  context.fillStyle = "black"
  if player is 1
    context.fillText "X", sq.x, sq.y
  else
    context.fillText "O", sq.x, sq.y

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

  $('canvas').click ->

