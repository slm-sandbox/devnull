module.exports = (io, app) ->
  
  A = 31
  B = 16

  Canvas = require 'canvas'
  canvas = new Canvas A, A
  ctx = canvas.getContext '2d'

  isCorridor = (tiles)->
    getTileState = (tile)->
      Board.get(tile.x, tile.y)

    tile = [getTileState(tiles[0]), getTileState(tiles[1]), getTileState(tiles[2]), getTileState(tiles[3])]
    if tile[0] == 1 and tile[1] == 1 and tile[2] == 0 and tile[3] == 0
      return true
    else if tile[0] == 0 and tile[1] == 0 and tile[2] == 1 and tile[3] == 1
      return true
    else
      return false

  getDistanceToPlayer = (entity, player)->
    x = player.x - entity.x
    y = player.y - entity.y
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
    min = [null, Infinity]

    for player in Player._all
      for tile in tiles
        distances.push [tile, getDistanceToPlayer(tile, player)] unless Board.get(tile.x, tile.y) == 0
      for d in distances
        if d[1] + Math.random() < min[1]
          min = d

    return min[0]

  farthestTile = (tiles)->
    distances = []
    max = [null, 0]

    for player in Player._all
      for tile in tiles
        distances.push [tile, getDistanceToPlayer(tile, player)] unless Board.get(tile.x, tile.y) == 0
      for d in distances
        if d[1] > max[1]
          max = d

    return max[0]

  class Entity
    @_all: []
    @remove: (entity)->
      Entity._all.splice idx, 1 if (idx = Entity._all.indexOf entity) != -1
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
        @x = sx + dx * Math.min(1, (Date.now() - st) / 250)
        @y = sy + dy * Math.min(1, (Date.now() - st) / 250)
        if Date.now() < st + 250
          setTimeout fn, 20
        else
          @postMove && @postMove()
      setTimeout fn, 20

  class Monster extends Entity
    @_all: []
    @remove: (monster)->
      clearInterval monster.myLoop
      Entity._all.splice idx, 1 if (idx = Entity._all.indexOf monster) != -1
    constructor: ->
      Monster._all.push @
      @state = 0
      super
      @dx = 0
      @dy = 0
      @myLoop = setInterval =>
        @tick()
      , 250
      module.exports.mainLoop.push @myLoop
    draw: (ctx)->
      ctx.fillStyle = ['blue', 'lightblue'][@state];
      ctx.fillRect(@x, @y, 1, 1);
    tick: ->
      tiles = getAdjacentTiles @
      if (@dx is 0 and @dy is 0) or !isCorridor(tiles)
        target = [closestTile, farthestTile][@state] tiles
        if target
          @dx = target.x - @x
          @dy = target.y - @y
        else
          @dx = @dy = 0

      @move @dx, @dy

      plrs = []
      for player in Player._all
        plrs.push player
      for player in plrs
        if getDistanceToPlayer(@, player) < 1
          if @state is 0
            player.socket.emit 'game-over'
            player.iamdead()
            Player.remove player
          else
            Monster.remove @

  class Player extends Entity
    @_all: []
    @_instance: null
    @remove: (player)->
      Entity.remove player
      Player._all.splice idx, 1 if (idx = Player._all.indexOf player) != -1
    constructor: ->
      Player._all.push @
      Player._instance = @
      super
    postMove: ->
      pill = Pill.get @x, @y
      if pill
        for m in Monster._all
          m.state = 1
        setTimeout ->
          for m in Monster._all
            m.state = 0
        , 5000
        Pill.remove pill

    draw: (ctx)->
      ctx.fillStyle = 'red'
      ctx.fillRect @x, @y, 1, 1

  class Pill extends Entity
    @_all: {}
    @get: (x, y)->
      Pill._all["#{x},#{y}"] || null
    @remove: (pill)->
      delete Pill._all["#{pill.x},#{pill.y}"]
      Entity._all.splice idx, 1 if (idx = Entity._all.indexOf pill) != -1
    constructor: ->
      super
      Pill._all["#{@x},#{@y}"] = @
    draw: (ctx)->
      ctx.fillStyle='#FFFF00'
      ctx.fillRect(@x,@y,1,1)

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
      ctx.fillStyle='black';
      ctx.fillRect(0,0,A,A);
      for y in [0...A]
        for x in [0...A]
          switch @[y][x]
            when 0
              ctx.fillStyle = 'teal'
              ctx.fillRect(x,y,1,1)
            when 1
              ctx.fillStyle = 'yellow'
              ctx.fillRect(x+.3,y+.3,.4,.4)
      for e in Entity._all
        e.draw ctx
      canvas.toDataURL (err, str)->
        io.sockets.emit 'draw', str

  board = new Board
  
  board.populate()
  
  start = ->

    module.exports.mainLoop = [setInterval board.draw.bind board, 500]

    start = ->

  start2 = ->

    new Monster 29, 1
    new Monster 29, 9
    new Monster 29, 19
    new Monster 29, 29

    new Pill 1, 3 + Math.round Math.random() * 5
    new Pill 1, 9 + Math.round Math.random() * 5
    new Pill 1, 16 + Math.round Math.random() * 5
    new Pill 1, 22 + Math.round Math.random() * 5

    start2 = ->

  io.sockets.on 'connection', (socket)->

    player = null

    socket.on 'join', ->
      return if player
      start()
      player = new Player 1, 1
      player.socket = socket
      player.iamdead = -> player = null
      start2()

    socket.on 'move', (dx, dy)->
      return unless player
      player.move dx, dy

