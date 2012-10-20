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

  return d[0]

module.exports = (io) ->
  console.log('application loaded')

  board = []

  player = 
    position:
      x:0
      y:0

  monster = 
    position:
      x:4
      y:2

  tiles = getAdjacentTiles player, monster
  tile = closestTile tiles, player, board
  monster.move(monster.x-tile[0], monster.y-tile[1])