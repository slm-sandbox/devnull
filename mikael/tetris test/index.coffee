start = [3,0]
currentPiece = null
context = null
board = null

class Piece
  constructor: (@object)->
    @currPos = [3, -1]

  updateX: ->
    @currPos[0] += 1
    for obj in @object
      obj[0] += 1

  updateY: ->
    @currPos[1] += 1
    for obj in @object
      obj[1] += 1

gameLoop = ->
  clear()
  currentPiece.updateY()
  redrawBoard()

redrawBoard = ->
  for x in [0..6]
    for y in [0..8]
      if board[x][y] == 1
        # draw here

clear = ->
  context.clearRect 10,10,280,360
  context.beginPath()
  context.rect 10,10,280,360
  context.fillStyle = "#fff"
  context.fill()
  context.lineWidth = 1
  context.strokeStyle = "#000"
  context.stroke()

window.onload = ->
  board = new Array()
  for x in [0..6]
    board[x] = new Array()
    for y in [0..8]
      board[y] = 0

  canvas = document.getElementById 'canvas'
  context = canvas.getContext '2d'

  clear()

  currentPiece = new Piece [[0,0], [0,-1], [0,-2], [0,-3]]
  currentPiece.draw()

  setInterval gameLoop, 1000