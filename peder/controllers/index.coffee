exports.index = (req, res) ->
  res.render 'index', { title: 'Awesome app' }

exports.tetris = (req, res) ->
  res.render 'tetris', { title: 'Tetris' }

