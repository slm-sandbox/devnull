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
        if @pong.