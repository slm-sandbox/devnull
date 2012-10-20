module.exports = (io) ->

  console.log('application loaded')

  io.sockets.on 'connection', (socket)->

    board = [[0,0,0],[0,0,0],[0,0,0]]

    user = 0
    computer = 0
    moves = 0

    X = 1
    O = 2

    didMove = ->
      console.log board
      moves++
      socket.emit 'board', board
      unless (w = anyWinner()) is 0
        socket.emit 'winner', w 
        return false
      if moves is 9
        socket.emit 'winner', 0
        return false
      return true

    doMove = ->
      x = Math.floor Math.random() * 3
      y = Math.floor Math.random() * 3
      until board[y][x] is 0
        x = (++x % 3)
        y = (++y % 3) if x is 0
      board[y][x] = computer
      didMove()

    anyWinner = ->
      console.log 'didWin(1)', didWin(1)
      console.log 'didWin(2)', didWin(2)
      return didWin(1) or didWin(2)

    didWin = (p)->
      #Horizontal
      return p if board[0][0] is p and board[0][1] is p and board[0][2] is p
      return p if board[1][0] is p and board[1][1] is p and board[1][2] is p
      return p if board[2][0] is p and board[2][1] is p and board[2][2] is p
      #Vertical
      return p if board[0][0] is p and board[1][0] is p and board[2][0] is p
      return p if board[0][1] is p and board[1][1] is p and board[2][1] is p
      return p if board[0][2] is p and board[1][2] is p and board[2][2] is p
      #Diagonal
      return p if board[0][0] is p and board[1][1] is p and board[2][2] is p
      return p if board[0][2] is p and board[1][1] is p and board[2][0] is p
      return 0

    socket.on 'join', (team)->
      user = team
      computer = if team is X then O else X
      doMove() if computer is X

    socket.on 'place', (x, y)->
      return unless board[y][x] is 0
      board[y][x] = user
      doMove() if didMove()







