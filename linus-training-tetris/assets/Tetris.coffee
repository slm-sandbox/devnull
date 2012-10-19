
B = 16

class Tetris

  constructor: (@socket, @i = null)->

    $div = $('<div />')
    @score = $('<span />').appendTo $div
    $div.append '<br />'
    @canvas = $('<canvas />').prop(width: 9*B, height: 16*B).appendTo $div
    @ctx = @canvas[0].getContext '2d'
    @ctx.scale B, B
    $div.appendTo 'body'

    socket.on 'state', (data)=>
      @draw(data[@i]) unless @i is null

    if @i is null
      @socket.emit 'join'
      @socket.on 'you-are', (n)=>
        $div.addClass 'tetris-' + (@i = n)
        $div.find('button').remove()
        $b1 = $('<button>&lt;-</button>').on 'click', -> socket.emit 'move', -1
        $b2 = $('<button>-&gt;</button>').on 'click', -> socket.emit 'move', +1
        $b3 = $('<button>rot</button>').on 'click', -> socket.emit 'rotate', +1
        $div.append('<br />').append($b1).append(' ').append($b3).append(' ').append $b2
    else
      $div.addClass 'tetris-' + @i

  draw: (state)->
    return unless state
    @score.text (if state.over then " !! #{state.score} !! " else state.score)
    @ctx.clearRect 0, 0, 9, 16
    for p in state.ps
      @ctx.fillStyle = p.color
      for s in p.subs
        @ctx.fillRect p.x + s.x, p.y + s.y, 1, 1
    @ctx.fillStyle = '#0033FF'
    if state.p
      for s in state.p.subs
        @ctx.fillRect state.p.x + s.x, state.p.y + s.y, 1, 1





window.Tetris = Tetris
