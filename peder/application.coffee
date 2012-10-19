module.exports = (io) ->

  board = []
  for i in [0..9]
    a = []
    board.push a
    for i in [0..9]
      a.push 0

  pieces = [ 
    [[0, 0], [1, 0], [2, 0], [3, 0]], 
    [[0, 0], [1, 0], [2, 0], [2, 1]], 
    [[0, 0], [1, 0], [1, 0], [1, 1]], 
    [[0, 0], [1, 0], [1, 1], [1, 2]]
  ]

  current =
    coords: ->
      @piece.map (a) =>
        [a[0] + @x, a[1] + @y]

  (init_current =->
    current.x = 4
    current.y = board.length
    current.piece = pieces[Math.floor(Math.random() * 4)]
  )()

  next_piece = ->
    current.coords().map (a) ->
      board[a[1]][a[0]] = 1
    init_current()

  collision = ->
    r = false    
    current.coords().map (a)->
      r = true if a[1] == 0
    current.coords().map (a) ->
      r = true if (a[1] < board.length and board[a[1]][a[0]] == 1) 
    r

  step = ->
    console.log board
    console.log current.coords()
    console.log "\n"
    next_piece() if collision()
    current.y -= 1

  setInterval step, 500

