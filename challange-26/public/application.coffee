
class Entity
  @_all = []
  constructor: (@x, @y)->
    Entity._all.push @
    @lock = 0
  move: (dx, dy)->
    return unless @lock <= Date.now()
    unless @collision dx, dy
      board[@y][@x] = 2
      draw()
      @lock = Date.now() + 250
      animate player, dx, dy
  collision: (dx, dy)->
    !board[@y + dy][@x + dx]


class Monster extends Entity
  draw: ->
    ctx.fillStyle = 'blue'
    ctx.fillRect @x, @y, 1, 1

class Player extends Entity
  draw: ->
    ctx.fillStyle = 'red'
    ctx.fillRect @x, @y, 1, 1

$ ->
  A = 31
  B = 16

  canvas = document.createElement 'canvas'
  canvas.height = A*B
  canvas.width = A*B
  ctx = canvas.getContext '2d'
  ctx.scale B, B

  document.body.appendChild canvas

  board = []
  player =
    x: 1
    y: 1
    lock: 0
    move: (dx, dy)->
      return unless @lock <= Date.now()
      unless @collision dx, dy
        board[@y][@x] = 2
        draw()
        @lock = Date.now() + 250
        animate player, dx, dy
    collision: (dx, dy)->
      !board[@y + dy][@x + dx]

  for y in [0...A]
    board.push []
    for x in [0...A]
      board[y].push 0

  draw = ->
    ctx.fillStyle = 'black'
    ctx.fillRect 0, 0, A, A
    for y in [0...A]
      for x in [0...A]
        switch board[y][x]
          when 0
            ctx.fillStyle = 'teal'
            ctx.fillRect x, y, 1, 1
          when 1
            ctx.fillStyle = 'yellow'
            ctx.fillRect x+.3, y+.3, .4, .4
    for e in Entity._all
      e.draw()
    

  animate = (obj, dx, dy)->
    sx = obj.x
    sy = obj.y
    c = 0
    i = setInterval ->
      if c++ is 25
        clearInterval i
      else
        obj.x = sx + dx/25*c
        obj.y = sy + dy/25*c
        draw()
    , 10

  for x in [1...30] when x%2 and (Math.random() > .5 or x in [1,29])
    for y in [1...30]
      board[y][x] = 2

  for y in [1...30] when y%2 and (Math.random() > .5 or x in [1,29])
    for x in [1...30]
      board[y][x] = 1

  draw()

  $(document).on 'keydown', (e) ->
  
    if (e.which == 37) #left
      player.move(-1, 0)     
  
    if (e.which == 38) #up
      player.move(0, -1)
  
    if (e.which == 39) #right
      player.move(1, 0)
  
    if (e.which == 40) #down
      player.move(0, 1)
  
