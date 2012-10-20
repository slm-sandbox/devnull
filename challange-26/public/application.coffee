
A = 31
B = 16

class Entity
  @_all: []
  constructor: (@x, @y)->
    Entity._all.push @
    @lock = 0
  move: (dx, dy)->
    return unless @lock <= Date.now()
    unless @collision dx, dy
      Board._instance[@y][@x] = 2
      draw()
      @lock = Date.now() + 250
      animate player, dx, dy
  collision: (dx, dy)->
    !Board._instance[@y + dy][@x + dx]
  animate = (dx, dy)->
    sx = @x
    sy = @y
    c = 0
    i = setInterval ->
      if c++ is 25
        clearInterval i
      else
        @x = sx + dx/25*c
        @y = sy + dy/25*c
        Board._instance.draw()
    , 10


class Monster extends Entity
  draw: (ctx)->
    ctx.fillStyle = 'blue'
    ctx.fillRect @x, @y, 1, 1

class Player extends Entity
  draw: (ctx)->
    ctx.fillStyle = 'red'
    ctx.fillRect @x, @y, 1, 1

class Board extends Array

  @_instance: null

  constructor: ->

    Board._instance = @

    @canvas = document.createElement 'canvas'
    @canvas.height = A*B
    @canvas.width = A*B
    @ctx = canvas.getContext '2d'
    @ctx.scale B, B

    document.body.appendChild @canvas

    for y in [0...A]
      @push []
      for x in [0...A]
        @[y].push 0

  populate: ->

    for x in [1...A-1] when x%2 and (Math.random() > .5 or x in [1,29])
      for y in [1...A-1]
        @[y][x] = 2

    for y in [1...A-1] when y%2 and (Math.random() > .5 or x in [1,29])
      for x in [1...A-1]
        @[y][x] = 2

  draw: ->
    @ctx.fillStyle = 'black'
    @ctx.fillRect 0, 0, A, A
    for y in [0...A]
      for x in [0...A]
        switch @[y][x]
          when 0
            @ctx.fillStyle = 'teal'
            @ctx.fillRect x, y, 1, 1
          when 1
            @ctx.fillStyle = 'yellow'
            @ctx.fillRect x+.3, y+.3, .4, .4
    for e in Entity._all
      e.draw @ctx
    
$ ->

  board = new Board
  player = new Player 1, 1

  Board.draw()

  $(document).on 'keydown', (e) ->
  
    if (e.which == 37) #left
      player.move(-1, 0)     
  
    if (e.which == 38) #up
      player.move(0, -1)
  
    if (e.which == 39) #right
      player.move(1, 0)
  
    if (e.which == 40) #down
      player.move(0, 1)
  
