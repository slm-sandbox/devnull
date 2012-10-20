canvas = null
context = null
pWidth = 10
pHeight = 80
ballWidth = 10
ballHeight = 10

$ ->
  window.socket = io.connect ''

  canvas = document.getElementById 'canvas'
  context = canvas.getContext '2d'

  console.log 'ready'

  $('#join').click ->
    socket.emit 'join'

  socket.on 'start', ->
    $('#join').hide()

  resizeCanvas = ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight

    socket.on 'state', (data)->
      draw(data)

  resizeCanvas()

draw = (data)->
  context.clearRect 0,0,canvas.width, canvas.height
  context.fillStyle = "#000000"
  context.fillRect 0, data.left-pHeight/2, pWidth, pHeight
  context.fillRect canvas.width - 10, data.right - pHeight/2, pWidth, pHeight
  context.fillRect data.pong.x, data.pong.y, ballWidth, ballHeight