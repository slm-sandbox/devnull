module.exports = (io) ->

  console.log('application loaded')

  io.sockets.on 'connection', (socket)->

    board = [[0,0,0],[0,0,0],[0,0,0]]

    X = 1
    O = 2

    doMove = ->
      x = Math.random() * 3
      y = Math.random() * 3
      until board[y][x] is 0
        x = (++x % 3)
        y = (++y % 3) if x is 0
      socket.emit 'board', board

    anyWinner = ->
      #Horizontal
      return board[0][0] if board[0][0] is board[0][1] is board[0][2] > 0
      return board[1][0] if board[1][0] is board[1][1] is board[1][2] > 0
      return board[2][0] if board[2][0] is board[2][1] is board[2][2] > 0
      #Vertical
      return board[0][0] if board[0][0] is board[1][0] is board[2][0] > 0
      return board[0][1] if board[0][1] is board[1][1] is board[2][1] > 0
      return board[0][2] if board[0][2] is board[1][2] is board[2][2] > 0
      #Diagonal
      return board[1][1] if board[0][0] is board[1][1] is board[2][2] > 0
      return board[1][1] if board[0][2] is board[1][1] is board[2][0] > 0
      return 0

    user = 0
    computer = 0

    socket.on 'join', (team)->
      user = team
      computer = if team is X then O else X
      doMove() if computer is X

    socket.on 'place', (x, y)->
      return unless board[y][x] is 0
      board[y][x] = user
      doMove()







