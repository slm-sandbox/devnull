
class P
  constructor: (@b, @x, @y)->
    @t = 1 + Math.floor Math.random 4
    @subs = switch @t
      when 0 then [{x: @x, y: @y}]
      when 1 then [{x: @x-1, y: @y}, {x: @x, y: @y}, {x: @x+1, y: @y}, {x: @x+2, y: @y}]
      when 2 then [{x: @x-1, y: @y}, {x: @x, y: @y}, {x: @x-1, y: @y+1}, {x: @x, y: @y+1}]
      when 3 then [{x: @x-1, y: @y-1}, {x: @x-1, y: @y}, {x: @x, y: @y}, {x: @x+1, y: @y}]
      when 4 then [{x: @x+1, y: @y}, {x: @x, y: @y}, {x: @x+1, y: @y}, {x: @x-1, y: @y}]
  move: (dx, dy)->
    unless @collision dx, dy
      @x += dx
      @y += dy
      true
    false
  collision: (dx = 0, dy = 0)->
    for o in @subs
      return true if o.x + dx < 0 or o.x + dx > 6 or o.y + dy > 15
    for p in Client.state[@b].ps
      for s in p.subs
        for o in @subs
          return true if s.x is o.x + dx and s.y is o.y + dy

class Client

  @state: [
    {
      p: null
      ps: []
    },{
      p: null
      ps: []
    }
  ]

  @setup: (io)->
    setInterval ->
      for s, b in Client.state
        unless s.p
          s.p = new P b, 3, -2
          #FIXME: game over if collision
        unless s.p.move 0, 1
          s.ps.push s.p
          s.p = null
      io.sockets.emit 'state', Client.state
    , 500

  constructor: (@socket)->
    @player = null
    @socket.on 'join', (data)=> @join data
    @socket.on 'move', (move)=> @join move

  join: (data)->
    @player = data

  move: (data)->
    
    return unless @player
    return unless Client.state[@player]
    return unless Client.state[@player].p

    Client.state[@player].p.move data, 0

module.exports = exports = Client
