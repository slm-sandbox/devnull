getAdjacentTiles = (player, monster)->
  mX = monster.x
  mY = monster.y

  adjTiles = []
  adjTiles.push [mX-1, mY]
  adjTiles.push [mX+1, mY]
  adjTiles.push [mX, mY-1]
  adjTiles.push [mX, mY+1]

  return adjTiles

closestTile = (tiles, player, board)->
  distances = []
  for tile in tiles
    unless board[tile[1]][tile[0]] == 0
      a = player.x - tile[0]
      b = player.y - tile[1] 
      distances.push [tile, Math.sqrt(a*a+b*b)]
  min = [null, Infinity]
  for d in distances
    if d[1] < min[1]
      min = d

  return min[0]

farthestTile = (tiles, player, board)->
  distances = []
  for tile in tiles
    unless board[tile[1]][tile[0]] == 0
      a = player.x - tile[0]
      b = player.y - tile[1] 
      distances.push [tile, Math.sqrt(a*a+b*b)]
  max = [null, 0]
  for d in distances
    if d[1] > max[1]
      max = d

  return max[0]

module.exports = (io) ->
  console.log('application loaded')

  board = []

  A = 5
  B = 5

  for y in [0...A]
    board.push []
    for x in [0...A]
      board[y].push 0

  for x in [1...A-1] when x%2 and (Math.random() > .5 or x in [1,29])
    for y in [1...B-1]
      board[y][x] = 2

  for y in [1...A-1] when y%2 and (Math.random() > .5 or x in [1,29])
    for x in [1...B-1]
      board[y][x] = 1

  player = 
    x:0
    y:0

  monster =     
    x:4
    y:2

  tiles = getAdjacentTiles player, monster
  tile = closestTile tiles, player, board
  console.log "player: " + player.x + " " + player.y
  console.log "monster: " + monster.x + " " + monster.y
  console.log tiles
  console.log tile

  #monster.move monster.x-tile[0], monster.y-tile[1]