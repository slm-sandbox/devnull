getAdjacentTiles = (monster)->
  mX = monster.x
  mY = monster.y

  adjTiles = []
  adjTiles.push [mX-1, mY]
  adjTiles.push [mX+1, mY]
  adjTiles.push [mX, mY-1]
  adjTiles.push [mX, mY+1]

  return adjTiles

closestTile = (tiles)->
  distances = []
  for tile in tiles
    unless Board.get(tile[0], tile[1]) == 0
      a = Player._instance.x - tile[0]
      b = Player._instance.y - tile[1] 
      distances.push [tile, Math.sqrt(a*a+b*b)]
  min = [null, Infinity]
  for d in distances
    if d[1] < min[1]
      min = d

  return min[0]

farthestTile = (tiles)->
  distances = []
  for tile in tiles
    unless Board.get(tile[0], tile[1]) == 0
      a = Player._instance.x - tile[0]
      b = Player._instance.y - tile[1] 
      distances.push [tile, Math.sqrt(a*a+b*b)]
  max = [null, 0]
  for d in distances
    if d[1] > max[1]
      max = d

  return max[0]

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
      Board.set @x, @y, 2
      @lock = Date.now() + 250
      @animate dx, dy
  collision: (dx, dy)->
    !Board.get @x + dx, @y + dy
  animate: (dx, dy)->
    sx = @x
    sy = @y
    c = 0
    i = setInterval =>
      if c++ is 25
        clearInterval i
      else
        @x = sx + dx/25*c
        @y = sy + dy/25*c
        Board._instance.draw()
    , 10


class Monster extends Entity
  constructor: ->
    @state = 0
    setInterval =>
      @tick()
    , 250
    super
  draw: (ctx)->
    ctx.fillStyle = 'blue'
    ctx.fillRect @x, @y, 1, 1
  tick: ->
    target = [closestTile, farthestTile][@state] getAdjacentTiles @
    @move target[0] - @x, target[1] - @y

class Player extends Entity
  @_instance: null
  constructor: ->
    Player._instance = @
    super
  draw: (ctx)->
    ctx.fillStyle = 'red'
    ctx.fillRect @x, @y, 1, 1

class Board extends Array

  @_instance: null

  @get: (x, y)->
    Board._instance[y][x]
  @set: (x, y, v)->
    Board._instance[y][x] = v
  @draw: ->
    Board._instance.draw()

  constructor: ->

    Board._instance = @

    @canvas = document.createElement 'canvas'
    @canvas.height = A*B
    @canvas.width = A*B
    @ctx = @canvas.getContext '2d'
    @ctx.scale B, B

    document.body.appendChild @canvas

    for y in [0...A]
      @push []
      for x in [0...A]
        @[y].push 0

  populate: ->

    for x in [1...A-1] when x%2 and (Math.random() > .5 or x in [1,29])
      for y in [1...A-1]
        @[y][x] = 1

    for y in [1...A-1] when y%2 and (Math.random() > .5 or x in [1,29])
      for x in [1...A-1]
        @[y][x] = 1

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
  
  new Monster 29, 1
  new Monster 29, 9
  new Monster 29, 19
  new Monster 29, 29

  board.populate()
  board.draw()

  $(document).on 'keydown', (e) ->
  
    if (e.which == 37) #left
      player.move(-1, 0)     
  
    if (e.which == 38) #up
      player.move(0, -1)
  
    if (e.which == 39) #right
      player.move(1, 0)
  
    if (e.which == 40) #down
      player.move(0, 1)
  