
randomcolor = ->
  [
    '#00FF00',
    '#00EE00',
    '#00FF33',
    '#00EE33',
    '#33FF00',
    '#33EE00',
    '#66FF33',
    '#33FF66'
  ][Math.floor Math.random() * 8]

class P
  constructor: (@b, @x, @y)->
    @r = 0
    @t = 1 + Math.floor Math.random() * 4
    @color = randomcolor()
    @subs = @_subs()
  move: (dx, dy)->
    unless @collision dx, dy
      @x += dx
      @y += dy
      return true
    return false
  rotate: (dr)->
    @r += dr
    @subs = @_subs()
    if @collision()
      @r -= dr
      @subs = @_subs()
      return false
    return true
  collision: (dx = 0, dy = 0)->
    for o in @subs
      return true if @x + o.x + dx < 0 or @x + o.x + dx > 8 or @y + o.y + dy > 15
    for p in Client.state[@b].ps
      for s in p.subs
        for o in @subs
          return true if p.x + s.x is @x + o.x + dx and p.y + s.y is @y + o.y + dy
    return false
  _subs: ->
    (switch @t
      when 0 then [{x: +0, y: +0}]
      when 1 then [{x: -1, y: -1}, {x: -1, y: +0}, {x: +0, y: -1}, {x: +0, y: +0}]
      when 2 then [{x: -1, y: +0}, {x: +0, y: +0}, {x: -1, y: +1}, {x: +0, y: +1}]
      when 3 then [{x: -1, y: -1}, {x: -1, y: +0}, {x: +0, y: +0}, {x: +1, y: +0}]
      when 4 then [{x: +1, y: +1}, {x: +0, y: +0}, {x: +1, y: +0}, {x: -1, y: +0}]
    ).map (p)=>
      switch (@r % 4)
        when 0 then { x: +p.x, y: +p.y }
        when 1 then { x: +p.y, y: -p.x }
        when 2 then { x: -p.x, y: -p.y }
        when 3 then { x: -p.y, y: +p.x }
    


class Client

  @state: []

  @setup: (io)->
    i = setInterval ->
      for s, b in Client.state

        continue if s.over

        if s.p is null
          s.p = new P b, 3, -2
          if s.p.collision()
            s.over = true
            io.sockets.emit 'game-over', b
        unless s.p.move 0, 1
          s.ps.push s.p
          s.p = null

        c = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        for q in s.ps
          for r in q.subs
            c[q.y + r.y]++
        for p, y in c
          continue if p < 9
          s.score++
          for q in s.ps
            new_subs = []
            for r in q.subs
              if q.y + r.y < y
                r.y++
                new_subs.push r
              if q.y + r.y > y
                new_subs.push r
            q.subs = new_subs

      io.sockets.emit 'state', Client.state
    , 300

  constructor: (@socket)->
    @player = null
    @socket.on 'join', (data)=> @join data
    @socket.on 'move', (data)=> @move data
    @socket.on 'rotate', (data)=> @rotate data
    @socket.emit 'setup', Client.state

  join: (data)->
    @player = Client.state.length
    Client.state.push
      p: null
      ps: []
      score: 0
      over: false
    @socket.broadcast.emit 'joined', @player
    @socket.emit 'you-are', @player

  move: (data)->
    
    return if @player is null
    return unless Client.state[@player]
    return unless Client.state[@player].p

    Client.state[@player].p.move data, 0
    @socket.emit 'state', Client.state

  rotate: (data)->

    return if @player is null
    return unless Client.state[@player]
    return unless Client.state[@player].p

    Client.state[@player].p.rotate data
    @socket.emit 'state', Client.state

module.exports = exports = Client
