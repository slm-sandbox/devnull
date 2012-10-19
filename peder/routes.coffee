
index = (req, res) ->
  res.render 'index', { title: 'Awesome app' }

tetris = (req, res) ->
  res.render 'tetris', { title: 'Tetris' }

module.exports = (app) ->
  app.get '/', index
  app.get '/tetris', tetris

