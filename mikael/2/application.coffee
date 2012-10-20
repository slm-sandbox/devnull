module.exports = (io) ->
  
  console.log('application loaded')

  io.sockets.on 'connection', (socket)->

    state =
      left: 50
      right: 50
      pong:
        x: 100
        y: 100
        dx: 4
        dy: 2
      over: false
      step: ->
        @pong.x += @pong.dx
        @pong.y += @pong.dy
        if @pong.y < 0
          @pong.y = -@pong.y
          @pong.dy = -@pong.dy
        if @pong.y > 600
          @pong.y = 600-(@pong.y-600)
          @pong.dy = -@pong.dy
        if @pong.x <= 0
          if @left - 25 >= @pong.y and @pong.y <= @left + 25
            @pong.x = -@pong.x
            @pong.dx = -@pong.dx
          else
            @over = true
        if @pong.x >= 800
          if @left - 25 >= @pong.y and @pong.y <= @left + 25
            @pong.x = 800-(@pong.x-800)
            @pong.dx = -@pong.dx
          else
            @over = true
        socket.emit 'state', @

    players = 0

    socket.on 'join', ()->
      console.log 'joining'
      if ++players is 2
        socket.emit 'start'
        setInterval ->
          state.step()
        , 150
    socket.on 'left', (dy)->
      state.left += dy
      socket.emit 'state', state
    socket.on 'right', (dy)->
      state.right += dy
      socket.emit 'state', state
