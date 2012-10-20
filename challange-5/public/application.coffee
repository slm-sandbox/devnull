socket = io.connect()
player = null;

join = (p)->
  player = p
  socket.emit 'join', p
  show p
  join = ->

$(document).on 'keydown', (e) ->

  if (e.which == 37) #left
    join 'left'

  if (e.which == 38) #up
    console.log player
    socket.emit player, -10

  if (e.which == 39) #right
    join 'right'

  if (e.which == 40) #down
    console.log player
    socket.emit player, 10

show = (player)->
  canvas = document.createElement 'canvas'
  canvas.width = 400
  canvas.height = 300
  $(canvas).addClass player
  document.body.appendChild canvas
  ctx = canvas.getContext '2d'

  socket.on 'state', (s)->
    console.log s
    ctx.fillStyle = '#00FF00'
    ctx.fillRect 0, 0, 400, 300
    ctx.fillRect s.pong.x - 2, s.pong.y - 2, 4, 4
    ctx.fillStyle = '#0000FF'
    ctx.fillRect 0, s.left - 25, 2, 50
    ctx.fillRect 398, s.right - 25, 2, 50
