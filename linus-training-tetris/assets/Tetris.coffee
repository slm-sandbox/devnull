
B = 16

randomcolor = ->
  [
    '#00FF00',
    '#00EE00',
    '#00FF11',
    '#00EE11',
    '#11FF00',
    '#11EE00',
    '#00FF33',
    '#33FF00',
  ][Math.floor Math.random 8]

class Tetris

  constructor: ->
    @canvas = $('<canvas />').prop(width: 9*B, height: 16*B).appendTo 'body'

  draw: (state)->
    ctx = @canvas[0].getContext '2d'
    ctx.scale B, B
    ctx.clearRect 0, 0, 9, 16
    for p in state.ps
      ctx.fillStyle = randomcolor()
      for s in p.subs
        ctx.fillRect s.x, s.y, 1, 1
    ctx.fillStyle = '#0033FF'
    for s in state.p.subs
      ctx.fillRect s.x, s.y, 1, 1




window.Tetris = Tetris
