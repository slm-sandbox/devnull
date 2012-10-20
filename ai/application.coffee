getAdjacentTiles = (player, monster)->
  mX = monster.x
  mY = monster.y

  adjTiles = []
  adjTiles.push [mX-1, mY]

  console.log adjTiles

module.exports = (io) ->
  console.log('application loaded')

  player = 
    position:
      x:0
      y:0

  monster = 
    position:
      x:4
      y:2

  getAdjacentTiles player, monster