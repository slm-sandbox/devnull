
isCorridor = (tiles)->
  getTileState = (tile)->
    Board.get(tile.x, tile.y)

  tile = [getTileState(tile[0]), getTileState(tile[1]), getTileState(tile[2]), getTileState(tile[3])]
  if tile[0] == 1 and tile[1] == 1 and tile[2] == 0 and tile[3] == 0
    return true
  else if tile[0] == 0 and tile[1] == 0 and tile[2] == 1 and tile[3] == 1
    return true
  else
    return false

getDistanceToPlayer = (entity)->
  x = Player._instance.x - entity.x
  y = Player._instance.y - entity.y
  return Math.sqrt(x*x+y*y)

getAdjacentTiles = (monster)->
  mX = monster.x
  mY = monster.y
  
  [
    {x: mX-1, y: mY-0}
    {x: mX+1, y: mY+0}
    {x: mX-0, y: mY-1}
    {x: mX+0, y: mY+1}
  ]

closestTile = (tiles)->
  distances = []
  for tile in tiles
    distances.push [tile, getDistanceToPlayer tile] unless Board.get(tile.x, tile.y) == 0
  min = [null, Infinity]
  for d in distances
    if d[1] + Math.random() < min[1]
      min = d

  return min[0]

farthestTile = (tiles)->
  distances = []
  for tile in tiles
    distances.push [tile, getDistanceToPlayer tile] unless Board.get(tile.x, tile.y) == 0
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
    sx = Math.round @x
    sy = Math.round @y
    st = Date.now()
    fn = =>
      if Date.now() < st + 250
        setTimeout fn, 20
      @x = sx + dx * Math.min(1, (Date.now() - st) / 250)
      @y = sy + dy * Math.min(1, (Date.now() - st) / 250)
    setTimeout fn, 20

class Monster extends Entity
  constructor: ->
    @state = 0
    window.mainLoop.push setInterval =>
      @tick()
    , 250
    super
  draw: (ctx)->
    ctx.fillStyle = 'blue'
    ctx.fillRect @x, @y, 1, 1
  tick: ->
    target = [closestTile, farthestTile][@state] getAdjacentTiles @
    @move target.x - @x, target.y - @y
    console.log getDistanceToPlayer @
    if getDistanceToPlayer(@) < 1
      console.log 'test'
      clearInterval i for i in window.mainLoop
      alert "You're dead!"

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
    Board._instance[Math.round y][Math.round x]
  @set: (x, y, v)->
    Board._instance[Math.round y][Math.round x] = v
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
  
  board.populate()
  
  window.mainLoop = [setInterval board.draw.bind board, 10]

  new Monster 29, 1
  new Monster 29, 9
  new Monster 29, 19
  new Monster 29, 29

  $(document).on 'keydown', (e) ->
  
    if (e.which == 37) #left
      player.move(-1, 0)     
  
    if (e.which == 38) #up
      player.move(0, -1)
  
    if (e.which == 39) #right
      player.move(1, 0)
  
    if (e.which == 40) #down
      player.move(0, 1)
  