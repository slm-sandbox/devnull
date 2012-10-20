$ ->
  A = 31
  B = 16

  canvas = document.createElement 'canvas'
  canvas.height = A*B
  canvas.width = A*B
  ctx = canvas.getContext '2d'
  ctx.scale B, B

  document.body.appendChild canvas

  board = []

  for y in [0...A]
    board.push []
    for x in [0...A]
      board[y].push 0

  draw = ->
    ctx.fillStyle = 'black'
    ctx.fillRect 0, 0, A, A
    for y in [0..A]
      for x in [0..A]
        switch board[y][x]
          when 0
            ctx.fillStyle = 'teal'
            ctx.fillRect x, y, 1, 1
          when 1
            ctx.fillStyle = 'yellow'
            ctx.fillRect x+.3, y+.3, .4, .4

  for x in [1...30] when x%2 and Math.random() > .5
    for y in [1...30]
      board[y][x] = 2

  for y in [1...30] when y%2 and Math.random() > .5
    for x in [1...30]
      board[y][x] = 1

  draw()

