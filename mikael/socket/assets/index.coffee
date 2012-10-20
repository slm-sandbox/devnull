context = null
increment = 40
socket = null

drawGraph = (data)->
  context.beginPath()
  for i in [0..data.length - 1]
    x = i*increment+increment
    y = 400 - data[i] * increment
    context.moveTo x, 400
    context.lineTo x, y
    context.stroke()

$ ->
  canvas = document.getElementById 'canvas'
  context = canvas.getContext '2d'

  context.beginPath()
  context.moveTo 0, 0
  context.lineTo 0, 400
  context.stroke()

  context.lineTo 600, 400
  context.stroke()

  socket = io.connect ''
  socket.on 'update', (data)->
    console.log "Updating"
    drawGraph data

  setInterval getData, 1000

getData = ->
  socket.emit 'get-data'