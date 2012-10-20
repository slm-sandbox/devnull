context = null
player = 3
cpu = 3

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

  socket.on 'board', (data)->
    for a, y in data
      for v, x in a
        drawPlay v, x:x, y:y unless v == 0

  $('canvas').click (e)->
    x = e.pageX
    y = e.pageY
    boardX = Math.floor(3*x/300)
    boardY = Math.floor(3*y/300)
    socket.emit 'place', boardX, boardY

  $('#x').click ->
    player = 1
    cpu = 2
    socket.emit 'join', player
    $('button').hide()

  $('#o').click ->
    player = 2
    cpu = 1
    socket.emit 'join', player
    $('button').hide()

  socket.on 'winner', (data)->
    if data == player
      alert('you win')
    else if data == 0
      alert('you fail')
    else if data == cpu
      alert('cpu wins')
