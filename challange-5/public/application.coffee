socket = io.connect 'http://localhost:3000'
player = null;

join = (player)->
  socket.emit 'join', player
  show player

$(document).on 'keydown', (e) ->

  if (e.which == 37) #left
    join 'left'

  if (e.which == 38) #up
    socket.emit player, -10   

  if (e.which == 39) #right
    join 'right'

  if (e.which == 40) #down
    socket.emit player, 10   

show = (player)->
  canvas = document.createElement 'canvas'
  $(canvas).addClass player
  document.appendChild canvas
  ctx = canvas.getContext '2d'

  socket.on 'state', (s)->
    ctx.fillStyle = '#00FF00'
    ctx.clearRect(0, 0, 800, 600)
    ctx.fillRect(s.pong.x - 2, s.pong.y - 2, 4, 4)
    ctx.fillStyle = '#0000FF'
    ctx.fillRect 0, s.left - 25, 2, 50
    ctx.fillRect 798, s.right - 25, 2, 50
