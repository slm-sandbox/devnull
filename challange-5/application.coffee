module.exports = (io) ->
  
  console.log('application loaded')

  state =
    left: 50
    right: 50
    pong:
      x: 50
      y: 50
      dx: 4
      dy: 2
    over: false
    step: ->
      @pong.x += @pong.dx
      @pong.y += @pong.dy
      if @pong.y < 0
        @pong.y = -@pong.y
        @pong.dy = -@pong.dy
      if @pong.y > 300
        @pong.y = 300-(@pong.y-300)
        @pong.dy = -@pong.dy
      if @pong.x <= 0
        if @left - 25 >= @pong.y and @pong.y <= @left + 25
          @pong.x = -@pong.x
          @pong.dx = -@pong.dx
        else
          @over = true
      if @pong.x >= 400
        if @left - 25 >= @pong.y and @pong.y <= @left + 25
          @pong.x = 400-(@pong.x-400)
          @pong.dx = -@pong.dx
        else
          @over = true
      io.sockets.emit 'state', @

  players = 0

  io.sockets.on 'connection', (socket)->
    socket.on 'join', ()->
      if ++players is 2
        setInterval ->
          state.step()
        , 150
    socket.on 'left', (dy)->
      state.left += dy
      io.sockets.emit 'state', state
    socket.on 'right', (dy)->
      state.right += dy
      io.sockets.emit 'state', state
